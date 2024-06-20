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
function Test-InteractiveSession {
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
function Set-OhMyPoshTheme {
    # Set Oh My Posh theme for the current PowerShell session
    $Config = "{0}\{1}.omp.json" -f $env:POSH_THEMES_PATH, $My.OhMyPoshTheme
    try {
        oh-my-posh init pwsh --config "$Config" | Invoke-Expression
    }
    catch {
        Write-Warning -Message ("Oh My Posh theme could not be loaded: {0}" -f $_.Exception.Message)
    }
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
    & $My.TextEditor $args
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
    param (
        [Parameter()]
        [Alias("a")]
        [switch] $ShowAll
    )
    # Print commands and aliases from my aide-memoire
    $AvailableCommands = @()
    $UnavailableCommands = @()
    $My.AideMemoire | ForEach-Object -Process {
        if (Test-Command $_.Command) {
            $AvailableCommands += [PSCustomObject] $_
        }
        else {
            $UnavailableCommands += [PSCustomObject] $_
        }
    }
    if ($ShowAll.IsPresent) {
        $AvailableCommands | ForEach-Object -Process { $_ | Add-Member -Name 'Available' -Type NoteProperty -Value $true }
        $UnavailableCommands | ForEach-Object -Process { $_ | Add-Member -Name 'Available' -Type NoteProperty -Value $false }
        $AvailableCommands + $UnavailableCommands | Sort-Object -Property Command | Format-Table Command, Description, Available -AutoSize
    }
    else {
        $AvailableCommands | Sort-Object -Property Command | Format-Table Command, Description -AutoSize
    }
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
function Convert-Base64 {
    param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [string] $String,
        [Parameter()]
        [Alias("d")]
        [switch] $Decode
    )
    if ($Decode.IsPresent) {
        [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($String))
    }
    else {
        [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($String))
    }
}
#endregion

#region Import Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path -Path $ChocolateyProfile) {
    Import-Module -Name "$ChocolateyProfile"
}
#endregion

#region Run in user interactive session
if (Test-InteractiveSession -and -not $NonInteractive.IsPresent) {
    #region Set environment variables
    $env:WORKSPACE = $My.Workspace
    $env:EDITOR = $My.TextEditor
    #endregion

    #region Create my aliases
    New-MyAlias my       Show-MyVariables       "Print my variables"
    New-MyAlias aide     Show-MyAideMemoire     "Print my aide-memoire for my commands and alias"
    New-MyAlias grep     Out-Grep               "Execute grep like in *nix"
    New-MyAlias ws       Use-Workspace          "Change directory to my workspace"
    New-MyAlias github   Open-GitHub            "Open GitHub profile page in default browser"
    New-MyAlias cm       Invoke-Chezmoi         "Execute chezmoi dotfiles manager"
    New-MyAlias histOn   Enable-History         "Enable shell history"
    New-MyAlias histOff  Disable-History        "Disable shell history"
    New-MyAlias ex       Invoke-FileExplorer    "Execute File Explorer"
    New-MyAlias ed       Invoke-Editor          "Open my text editor"
    New-MyAlias pathUpd  Update-EnvPath         "Refresh PATH environment variable"
    New-MyAlias base64   Convert-Base64         "Base64 Encode and Decode"
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
    if (Test-Command "kubectx") { New-MyAlias kctx "kubectx.exe" "Run kubectx cmdline tool" }
    if (Test-Command "kubens") { New-MyAlias kns "kubens.exe" "Run kubens cmdline tool" }
    #endregion

    #region Print greeting message
    $GreetingMessage = "`nGreetings, Professor {0}. Shall we play a game?`n" -f $My.Name
    Write-Host $GreetingMessage -ForegroundColor Yellow
    #endregion
}
#endregion
