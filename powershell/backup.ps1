$include=@("*.dll","*.exe")
$files = get-childitem -path "c:\FolderName\*" -Include $include

$archive = "C:\ArchivePath"
$tempFolder=Join-Path -Path $archive -ChildPath "temp"
Remove-Item $tempFolder -Recurse -ErrorAction Ignore
MD $tempFolder -EA 0 | Out-Null
Copy-Item -Path $files -Destination $tempFolder
$files = Get-ChildItem -Path "$($tempFolder)\*" -Include $include
$name = "ProjectName_$($(get-date -f MM-dd-yyyy_HH_mm_ss))"+".zip"


$archiveFile = Join-Path -Path $archive -ChildPath $name

MD $archive -EA 0 | Out-Null


$Error.Clear()
foreach($file in $files)
{
    Compress-Archive -LiteralPath $file.FullName -Update -DestinationPath $archiveFile
    if ($Error.Count -gt 0)
    {
        Write-Error "Failed to archive $($file)"
    }
}
Remove-Item $tempFolder -Recurse
