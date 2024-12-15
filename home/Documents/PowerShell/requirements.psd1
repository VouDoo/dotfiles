@{
    PSDependOptions = @{
        Target     = "CurrentUser"
        Repository = "PSGallery"
    }

    # Modules
    "PSReadLine"    = @{
        Version    = "latest"
        Parameters = @{
            AllowPrerelease = $true
        }
    }
    "Portal"        = "latest"
    "MyJavaManager" = "latest"
}
