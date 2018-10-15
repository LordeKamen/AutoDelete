#Path that has the folders and files that must be deleted upon a certain amount of days.
$PathToDelete = ""
#Amount of days that will be used to delete old files
$timeDays = 7
$timeObject = new-timespan -Days $timeDays
$files = Get-ChildItem $PathToDelete -Recurse -File


# Delete files that are older than the time specified in $timeDays.
foreach ($file in $files) {
    $file_age = (Get-Item $file.FullName).CreationTime
    if (((Get-Date) - $file_age) -gt $timeObject) {
        Remove-Item $file.FullName
        Write-Debug ("Deleting file " + $file)
    }
}

# Delete empty directories.
do {
  $dirs = Get-ChildItem $PathToDelete -directory -recurse | Where-Object { (Get-ChildItem $_.fullName).count -eq 0 } | Select-Object -expandproperty FullName
  $dirs | Foreach-Object { Remove-Item $_ -Recurse -Force }
} while ($dirs.count -gt 0)
