#disable services
get-service | Where-Object {$_.Name -match "some names" -And $_.Name -Notmatch "other names" } | Set-Service -StartupType Disabled
#get MSMQ lists
$queue_list = Get-WmiObject -query "Select * from Win32_PerfRawData_MSMQ_MSMQQueue" |? {$_.Name -match "$hostname"}
#refersh message count
$queues = gwmi -class Win32_PerfRawData_MSMQ_MSMQQueue
#write something out
Write-Host "Dodgy happens"