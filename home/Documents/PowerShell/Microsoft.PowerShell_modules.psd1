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
    #"posh-git"        = "latest"  # managed by scoop
    #"Terminal-Icons"  = "latest"  # managed by scoop
    "BurntToast"      = "latest"
    "MyRemoteManager" = "latest"
    "MyJavaManager"   = "latest"
    "PomoShell"       = "latest"
}
