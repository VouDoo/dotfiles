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

#region Define profile variables
# Set path to my workspace directory
$script:MyWorkspace = "$HOME\Workspace"
# Set text editor variables
$script:TextEditor = "code.cmd"  # Visual Studio Code
$script:TextEditorWithWait = "{0} --wait" -f $TextEditor
#endregion

#region Define helper functions
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
}
function Test-InteractiveSession {
    # Test if the session is interactive
    [Environment]::GetCommandLineArgs() -notcontains "-NonInteractive"
}
function Test-Command {
    # Test if a command is present
    if (Get-Command -Name $args -ErrorAction SilentlyContinue) { $true } else { $false }
}
function Update-EnvPath {
    # Refresh PATH environment variable
    $Separator = [System.IO.Path]::PathSeparator
    $Paths = "Machine", "User" | ForEach-Object -Process {
        [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::"$_") -split $Separator | Where-Object { $_ } | Select-Object -Unique
    }
    $env:Path = $Paths -join $Separator
}
function Install-MyModules {
    # Install modules from the requirements file
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Repository PSGallery
    }
    Import-Module -Name PSDepend
    Invoke-PSDepend -Path "$PSScriptRoot\requirements.psd1" -Install -Import -Force
}
function Start-Starship {
    # Initialize Starship
    $env:STARSHIP_CONFIG = "$HOME\.config\starship\config.toml"
    Invoke-Expression (& starship init powershell)
}
function Invoke-Chezmoi {
    # Wrapper for chezmoi command
    $EditorPrevValue, $env:EDITOR = $env:EDITOR, $TextEditorWithWait
    try { & chezmoi.exe $args }
    finally { $env:EDITOR = $EditorPrevValue }
}
function Invoke-FileExplorer {
    # Browse current location with File Explorer
    & explorer.exe (Get-Location)
}
function Invoke-Editor {
    # Invoke my text editor
    & $TextEditor $args
}
function Use-MyWorkspace {
    # Move to my workspace
    if (-not (Test-Path -Path $MyWorkspace -PathType Container)) {
        New-Item -Path $MyWorkspace -ItemType Directory
    }
    Set-Location -Path $MyWorkspace
}
function Enable-History {
    # Enable shell history
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
}
function Disable-History {
    # Disable shell history
    Set-PSReadLineOption -HistorySaveStyle SaveNothing
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

#region Run in user interactive session
if (Test-InteractiveSession -and -not $NonInteractive.IsPresent) {
    #region Create my aliases
    New-MyAlias pathUpd  Update-EnvPath         "Refresh PATH environment variable"
    New-MyAlias cm       Invoke-Chezmoi         "Execute chezmoi dotfiles manager"
    New-MyAlias ex       Invoke-FileExplorer    "Execute File Explorer"
    New-MyAlias ed       Invoke-Editor          "Open my text editor"
    New-MyAlias ws       Use-MyWorkspace        "Change current directory to my workspace"
    New-MyAlias histOn   Enable-History         "Enable shell history"
    New-MyAlias histOff  Disable-History        "Disable shell history"
    New-MyAlias base64   Convert-Base64         "Base64 Encode and Decode"
    if (Test-Command "rg") {
        New-MyAlias grep "rg" "Execute ripgrep"
    }
    if (Test-Command "kubectl") {
        # Note for myself:
        # kubectl is the main tool for Kubernetes management and development.
        # So, if it is found, let's assume that the other tools are present too.
        $env:KUBE_EDITOR = $TextEditorWithWait
        & kubectl completion powershell | Out-String | Invoke-Expression
        New-MyAlias k "kubectl" "Run kubectl cmdline tool"
        if (Test-Command "k9s") {
            $env:K9S_EDITOR = $TextEditorWithWait
            New-MyAlias k9s "k9s" "Run k9s cmdline tool"
        }
        if (Test-Command "kubectx") {
            New-MyAlias kctx "kubectx" "Run kubectx cmdline tool"
        }
        if (Test-Command "kubens") {
            New-MyAlias kns "kubens" "Run kubens cmdline tool"
        }
    }
    #endregion

    #region Set PSFzf module
    # Set PSReadline related options
    Set-PsFzfOption -PSReadlineChordProvider "Ctrl+t"
    Set-PsFzfOption -PSReadlineChordReverseHistory "Ctrl+r"
    # Enable alias
    Set-PsFzfOption -EnableAliasFuzzyScoop
    Set-PsFzfOption -EnableAliasFuzzyEdit
    #endregion

    #region Set PSReadLine module
    # Import module
    Import-Module PSReadLine
    # Set options and key handlers
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin -BellStyle Visual
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    #endregion

    #region Set my modules
    # Import modules
    Import-Module MyRemoteManager
    Import-Module MyJavaManager
    # Create aliases
    New-MyAlias co      Invoke-MyRMConnection   "Invoke MyRemoteManager connection"
    New-MyAlias coTest  Test-MyRMConnection     "Test MyRemoteManager connection"
    New-MyAlias coGet   Get-MyRMConnection      "Get MyRemoteManager connections"
    New-MyAlias coAdd   Add-MyRMConnection      "Add MyRemoteManager connection"
    New-MyAlias coRm    Remove-MyRMConnection   "Remove MyRemoteManager connection"
    #endregion

    #region Set custom prompt
    # Import modules
    Import-Module posh-git
    Import-Module Terminal-Icons
    # Initialize Starship
    Start-Starship
    #endregion

    #region Print greeting message
    Write-Host ("`nGreetings, Professor Maxence. Shall we play a game?`n") -ForegroundColor Yellow
    #endregion
}
#endregion
