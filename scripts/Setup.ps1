param(
	[Parameter(Mandatory=$true)][string] $packages,
	[Parameter(Mandatory=$true)][string] $labSource)
cls

# Install Chocolatey
$sb = { iex ((new-object System.Net.Webclient).DownloadString('https://chocolatey.org/install.ps1')) }
Invoke-Command -ScriptBlock $sb

# Install Chocolatey packages
$packages.Split(";") | ForEach {
    $command = "cinst " + $_ + " -y -force"
    $sb = [scriptblock]::Create("$command")

    Invoke-Command -ScriptBlock $sb -ArgumentList $packages
}

# Download and unpack labs
Add-Type -AssemblyName System.IO.Compression.FileSystem
Remove-Item 'C:\Labs\' -Recurse -ErrorAction Ignore
$tmpName = [System.IO.Path]::GetRandomFileName
$tmpFolder = "C:\_content"

# If the folder already exists, remove it and any contents
Remove-Item $tmpFolder -Recurse -Force -ErrorAction Ignore

# Create the folder
md -Path $tmpFolder
$tmpFile = "$tmpFolder\labs.zip"

# Download and extract the labs
"Downloading $labSource to $tmpFile"
(new-object System.Net.Webclient).DownloadFile($labSource, $tmpFile)
[System.IO.Compression.ZipFile]::ExtractToDirectory($tmpFile, 'C:\')

# Cleanup
rd -Path $tmpFolder -Recurse -Force
