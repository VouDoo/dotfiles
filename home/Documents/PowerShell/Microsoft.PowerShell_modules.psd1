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
    "BurntToast"      = "latest"
    "MyRemoteManager" = "latest"
    "MyJavaManager"   = "latest"
    "PomoShell"       = "latest"
}
