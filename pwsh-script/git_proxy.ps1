# This is a script building for the main reason to bypass a private network
# to access the Internet by using a proxy domain name server.

$browser = New-Object System.Net.WebClient
$browser.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
if ($browser.Proxy) {
  Write-Host -NoNewline -ForegroundColor Green "Proxy credential detected!"
}

$proxyAddr = [System.Net.WebProxy]::GetDefaultProxy().Address
if ($null -eq $proxyAddr) {
  $proxies = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings')

  $proxyServer = $proxies.ProxyServer
  $proxyHost = ($proxyServer.Split(":") | Select-Object -First 2 | Select-Object -Last 1) -replace "\/", ""
  $proxyPort = $proxyServer.Split(":") | Select-Object -First 3 | Select-Object -Last 1

  $ipV4 = IPLookUp "${proxyHost}"
  ActiveProxyGit "$ipV4" "$proxyPort"

  # Script addresess
  if ($null -eq $proxyAddr) {
    $proxyAddr = $proxies.AutoConfigURL
    $proxyHost = ($proxyAddr.Split("/") | Select-Object -First 3 | Select-Object -Last 1).Split(":") | `
      Select-Object -First 1
    $proxyPort = ($proxyAddr.Split("/") | Select-Object -First 3 | Select-Object -Last 1).Split(":") | `
      Select-Object -First 2 | `
      Select-Object -Last 1

    $ipV4 = IPLookUp "${proxyHost}"
    ActiveProxyGit $ipV4 $proxyPort
  }
}

# When the system was already declared `ProxyServer` property
$proxyPort = $proxyAddr.Port
$proxyHost = $proxyAddr.Host

$ipV4 = IPLookUp "${proxyHost}"
ActiveProxyGit "${ipV4}:${proxyPort}"

function ActiveProxyGit {
  param (
    [String] $ipV4,
    [String] $proxyPort
  )
  git config --global http.sslverify false
  git config --global http.proxy "http://${ipV4}:${proxyPort}"
}

function IPLookUp {
  param (
    [String] $proxyHost
  )
  nslookup.exe "$proxyHost" | `
    findstr /r /c:"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$" | `
    Select-Object -First 2 | `
    Select-Object -Last 1
}