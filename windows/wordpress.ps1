# Set temporary variables to be used during the WordPress installation
$IIS_PATH = "$env:SystemDrive\inetpub"
$WORDPRESS_PATH = "$IIS_PATH\wordpress"
$WORDPRESS_URL = "https://wordpress.org/latest.zip"
$WORDPRESS_ZIP = "C:\Users\Administrator\Downloads\" + $(Split-Path -Path $WORDPRESS_URL -Leaf)

# Download and install WordPress
"`r`nWordPress ..."
"  - Downloading"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
#$webproxy = New-Object System.Net.WebProxy("http://16.85.88.10:8080",$true)
$web = New-Object System.Net.WebClient
$web.Proxy = $webproxy
$web.DownloadFile($WORDPRESS_URL, $WORDPRESS_ZIP)
"  - Expanding"
New-Item $WORDPRESS_PATH -ItemType Directory -Force | Out-Null
$ExtractShell = New-Object -ComObject Shell.Application 
$Files = $ExtractShell.Namespace($WORDPRESS_ZIP).Items() 
$ExtractShell.NameSpace($WORDPRESS_PATH).CopyHere($Files)


# Create a new Internet Information Services application pool for WordPress
"  - Creating Application Pool"
$WebAppPool = New-WebAppPool "WordPress"
$WebAppPool.managedPipelineMode = "Classic"
$WebAppPool.managedRuntimeVersion = ""
$WebAppPool | Set-Item

# Create a new Internet Information Services website for WordPress
"  - Creating WebSite"
New-Website "WordPress" -ApplicationPool "WordPress" -PhysicalPath "$WORDPRESS_PATH"  | Out-Null

# Remove the “Default Web Site” and start the new “WordPress” website
"  - Activating WebSite"
Remove-Website "Default Web Site"
Start-Website "WordPress"

"Done."
