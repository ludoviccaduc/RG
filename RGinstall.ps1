#REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\RG Systemes\RG Supervision\agent\options" /v ssl-ignore-errors-3rdparty /t REG_SZ /d true /f

Param ([string]$argumentduscript)

if (!(Test-Path C:\CADUC)) {
    New-Item -ItemType directory -Path C:\CADUC | Out-Null
}

if (!(Test-Path C:\CADUC\RG)) {
    New-Item -ItemType directory -Path C:\CADUC\RG | Out-Null
}

$url = "ftp://ftp.caduc.fr/RG/RGplus.exe"
$outpath = "C:\\CADUC\\RG\\RGplus.exe"

if ([System.IO.File]::Exists($outpath)) {
    Remove-Item -path $outpath -force | Out-Null
}

Invoke-WebRequest -Uri $url -OutFile $outpath | Out-Null

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = $outpath
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = $argumentduscript
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$stdout = $p.StandardOutput.ReadToEnd()
#$stderr = $p.StandardError.ReadToEnd()
Write-Host "$stdout"
#Write-Host "stderr: $stderr"
#Write-Host $p.ExitCode
exit $p.ExitCode