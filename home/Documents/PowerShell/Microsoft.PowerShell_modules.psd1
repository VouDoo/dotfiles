@{
    PSDependOptions   = @{
        Target     = "CurrentUser"
        Repository = "PSGallery"
    }

    # Modules
    "PSReadLine"      = @{
        Version    = "latest"
        Parameters = @{
            AllowPrerelease = $true
        }
    }
    "posh-git"        = "latest"
    "Terminal-Icons"  = "latest"
    "BurntToast"      = "latest"
    "MyRemoteManager" = "latest"
    "MyJavaManager"   = "latest"
    "PomoShell"       = "latest"
}
