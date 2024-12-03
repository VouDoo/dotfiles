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
    "MyRemoteManager" = "latest"
    "MyJavaManager"   = "latest"
}
