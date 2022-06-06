# NOTE: You can see all the list of all current active certificates in the 'certmgr' application.
# Path: Trusted Root Certification Authorities -> Certificates

# Right click to the certificate you want to export -> All Tasks -> Export, 
# with a given directory (eg: Documents\Cert\<your_cert>.cer)

# Adding this certificate (eg: SSLCERT_PATH) to the Enviroment Variables 
# (manually with the 'Edit the system enviroment variables')
# [System.Environment]::SetEnvironmentVariable('SSLCERT_PATH', '<cert_contents>')

$SSL_CERT = [System.Environment]::GetEnvironmentVariable('SSLCERT_PATH')
# $SSL_CERT = $env:Path.Split(";") | findstr cer

$GIT_PATH = Get-Command -Name git -ErrorAction SilentlyContinue | 
            Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue

if ( $? ) {
    git config –global http.sslverify true
    git config –global http.sslcainfo ${SSL_CERT}
    git config –global –l
} else {
    Write-Host -NoNewline "Local machine hasn't installed git yet"
}
