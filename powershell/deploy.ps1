param(
   [string] $source
)
$clock = 50
$Error.Clear()
$dllSourcePath="c:\Deployment\"+$source+"\*.dll"
$exeSourcePath="c:\Deployment\"+$source+"\*.exe"
while($clock -gt 0)
{
    $Error.Clear()
    Copy-Item  -Path $dllSourcePath -Destination "c:\Destination\"
    Copy-Item  -Path $exeSourcePath -Destination "c:\Destination\"
    if ($Error.Count -gt 0)
    {
        $clock--
        Start-Sleep -s 1
    }
    else
    {
        $clock = 0
    }
}
if ($Error.Count -gt 0)
{
    write-error "Deployment failed, please read the log"
    exit(1)
}
else
{
    Write-Host "Deployment Completed"
}