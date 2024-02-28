<#
    .SYNOPSIS
    PowerShell profile.

    .DESCRIPTION
    This file is a startup script to customize the PowerShell environment and add session-specific elements to every PowerShell session.

    .NOTES
    This profile is designed for Windows only.

#>

param (
    [Parameter()]
    [switch] $NonInteractive
)

#region Set my variables (My hashtable)
[hashtable] $My = Import-PowerShellDataFile -Path "$PSScriptRoot\Microsoft.PowerShell_my.psd1"
#endregion

#region Define helper functions
function Show-MyVariables {
    # Print key/value pairs from My hashtable
    $My.GetEnumerator() | ForEach-Object -Process {
        Write-Output -InputObject ("{0}={1}" -f $_.Key, $_.Value)
    }
}
function Test-Interactive {
    # Test if the session is interactive
    [Environment]::GetCommandLineArgs() -notcontains "-NonInteractive"
}
function Test-Command {
    # Test if a command is present
    param (
        [Parameter(Position = 0)]
        [string] $Command
    )
    if (Get-Command -Name $Command -ErrorAction SilentlyContinue) { $true } else { $false }
}
function Update-EnvPath {
    # Refresh PATH environment variable
    $Separator = [System.IO.Path]::PathSeparator
    $Paths = "Machine", "User" | ForEach-Object -Process {
        [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::"$_") -split $Separator | Where-Object { $_ } | Select-Object -Unique
    }
    $env:Path = $Paths -join $Separator
}
function Install-PSCore {
    # Install the latest version of PowerShell Core
    # Official installation documentation: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows
    if (Test-Command "winget") { & winget install --id "Microsoft.Powershell" --source winget }
    else {
        # Fall back on the old fashion way to install PowerShell
        "& { $(Invoke-RestMethod -Uri "https://aka.ms/install-powershell.ps1") } -UseMSI -AddExplorerContextMenu" | Invoke-Expression
    }
}
function Install-Chocolatey {
    # Install the latest version of Chocolatey
    # Official installation documentation: https://chocolatey.org/install
    Set-ExecutionPolicy -Scope Process -Force -ExecutionPolicy Bypass
    Invoke-RestMethod -Uri "https://chocolatey.org/install.ps1" | Invoke-Expression
}
function Install-Scoop {
    # Install the latest version of Scoop
    # Official installation documentation: https://scoop.sh/
    Set-ExecutionPolicy -Scope Process -Force -ExecutionPolicy RemoteSigned
    Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
}
function Install-OhMyPosh {
    # Install latest version of Oh My Posh
    # Official installation documentation: https://ohmyposh.dev/docs/installation/windows
    param (
        [Parameter(HelpMessage = "Choose a method to install Oh My Posh")]
        [ValidateSet("winget", "scoop", "manual")]
        [string] $Method = "winget"
    )
    switch ($Method) {
        "winget" {
            if (Test-Command "winget") { & winget install --id  "JanDeDobbeleer.OhMyPosh" --source winget winget }
            else {
                Write-Error -Message "Windows Package Manager CLI (aka. winget) must be installed to install Oh My Posh."
            }
        }
        "scoop" {
            if (Test-Command "scoop") { & scoop install "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json" }
            else {
                Write-Error -Message "scoop must be installed to install Oh My Posh."
            }
        }
        "manual" {
            Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
            Invoke-RestMethod -Uri "https://ohmyposh.dev/install.ps1" | Invoke-Expression
        }
        Default {
            Write-Error -Message "Invalid method to install Oh My Posh."
        }
    }
}
function Set-OhMyPoshTheme {
    # Set Oh My Posh theme for the current PowerShell session
    $Config = "{0}\{1}.omp.json" -f $env:POSH_THEMES_PATH, $My.OhMyPoshTheme
    oh-my-posh init pwsh --config "$Config" | Invoke-Expression
}
function Install-MyModules {
    # Install modules from the requirements file
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Repository PSGallery
    }
    Import-Module -Name PSDepend
    Invoke-PSDepend -Path "$PSScriptRoot\Microsoft.PowerShell_modules.psd1" -Install -Import -Force
}
function Out-Grep {
    # grep like in *nix systems
    $input | Out-String -Stream | Select-String $args
}
function Use-Workspace {
    # Set location to my workspace
    Set-Location -Path $My.Workspace
}
function Open-GitHubProfile {
    # Open GitHub profile page in default browser
    Start-Process -FilePath ("https://github.com/{0}" -f $My.GitHub)
}
function Invoke-Chezmoi {
    # Wrapper for chezmoi command
    $Prev, $env:EDITOR = $env:EDITOR, "code.cmd --wait"
    try { & chezmoi.exe $args }
    finally { $env:EDITOR = $Prev }
}
function Invoke-FileExplorer {
    # Browse current location with File Explorer
    & explorer.exe (Get-Location)
}
function Invoke-Editor {
    # Invoke my text editor
    & $My.TextEditor
}
function Enable-History {
    # Enable shell history
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
}
function Disable-History {
    # Disable shell history
    Set-PSReadLineOption -HistorySaveStyle SaveNothing
}
function New-MyAideMemoireEntry {
    # Create a new entry in my aide-memoire
    param (
        [Parameter(Position = 0)]
        [string] $Command,
        [Parameter(Position = 1)]
        [string] $Description
    )
    $global:My.AideMemoire += @{ Command = $Command; Description = $Description }
}
function Show-MyAideMemoire {
    # Print commands and aliases from my aide-memoire
    $My.AideMemoire | ForEach-Object -Process { [PSCustomObject] $_ } | Sort-Object -Property Command | Format-Table Command,Description -AutoSize
}
function New-MyAlias {
    # Create a new alias
    param (
        [Parameter(Position = 0)]
        [string] $Name,
        [Parameter(Position = 1)]
        [string] $Command,
        [Parameter(Position = 2)]
        [string] $Description
    )
    New-Alias -Name $Name -Value $Command -Description $Description -ErrorAction Continue -Option ReadOnly -Scope Script
    New-MyAideMemoireEntry -Command $Name -Description $Description
}
#endregion

#region Import Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path -Path $ChocolateyProfile) {
    Import-Module -Name "$ChocolateyProfile"
}
#endregion

#region Run in user interactive session
if (Test-Interactive -and -not $NonInteractive.IsPresent) {
    #region Set environment variables
    $env:WORKSPACE = $My.Workspace
    $env:EDITOR = $My.TextEditor
    #endregion

    #region Create my aliases
    New-MyAlias my      Show-MyVariables    "Print my variables"
    New-MyAlias aide    Show-MyAideMemoire  "Print my aide-memoire for my commands and alias"
    New-MyAlias grep    Out-Grep            "Execute grep like in *nix"
    New-MyAlias ws      Use-Workspace       "Change directory to my workspace"
    New-MyAlias github  Open-GitHub         "Open GitHub profile page in default browser"
    New-MyAlias cm      Invoke-Chezmoi      "Execute chezmoi dotfiles manager"
    New-MyAlias histOn  Enable-History      "Enable shell history"
    New-MyAlias histOff Disable-History     "Disable shell history"
    New-MyAlias ex      Invoke-FileExplorer "Execute File Explorer"
    New-MyAlias ed      Invoke-Editor       "Open my text editor"
    #endregion

    #region Set PSFzf module
    # Set PSReadline related options
    Set-PsFzfOption -PSReadlineChordProvider "Ctrl+t"
    Set-PsFzfOption -PSReadlineChordReverseHistory "Ctrl+r"
    # Enable alias
    Set-PsFzfOption -EnableAliasFuzzyScoop
    New-MyAideMemoireEntry fs "Execute scoop with fuzzy finder"
    Set-PsFzfOption -EnableAliasFuzzyEdit
    New-MyAideMemoireEntry fe "Execute editor with fuzzy finder"
    #endregion

    #region Set PSReadLine module
    # Import module
    Import-Module PSReadLine
    # Set options and key handlers
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin -BellStyle Visual
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    #endregion

    #region Set MyRemoteManager module
    # Import module
    Import-Module MyRemoteManager
    # Create aliases
    New-MyAlias co      Invoke-MyRMConnection   "Invoke MyRemoteManager connection"
    New-MyAlias coTest  Test-MyRMConnection     "Test MyRemoteManager connection"
    New-MyAlias coGet   Get-MyRMConnection      "Get MyRemoteManager connections"
    New-MyAlias coAdd   Add-MyRMConnection      "Add MyRemoteManager connection"
    New-MyAlias coRm    Remove-MyRMConnection   "Remove MyRemoteManager connection"
    #endregion

    #region Set Posh module
    # Import module
    Import-Module posh-git
    # Set Oh My Posh theme
    Set-OhMyPoshTheme
    #endregion

    #region Import other modules
    Import-Module Terminal-Icons
    Import-Module MyJavaManager
    Import-Module PomoShell
    #endregion

    #region Set Kubernetes related stuff
    if (Test-Command "kubectl") {
        # Set KUBE_EDITOR environment variable for kubectl
        $env:KUBE_EDITOR = $My.KubeEditor
        # Create alias for kubectl
        New-MyAlias k "kubectl.exe" "Run kubectl cmdline tool"
    }
    #endregion

    #region Print greeting message
    $GreetingMessage = "Greetings, Professor {0}. Shall we play a game?`n" -f $My.Name
    Write-Host $GreetingMessage -ForegroundColor Yellow
    #endregion
}
#endregion
