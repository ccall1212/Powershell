# Very Simple Network Test with System Info
# Just does basic tests and shows you the raw results

Write-Host "Network and System Test Starting..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Step 1: Comprehensive Network Test..." -ForegroundColor Cyan
Write-Host "Testing internet connection and speed to multiple sites..." -ForegroundColor Gray

# Test connection to Google
Write-Host "Pinging Google.com..." -ForegroundColor Red
Test-Connection -ComputerName "google.com" -Count 2

Write-Host ""
Write-Host "Pinging Alianza.com..." -ForegroundColor Green
Test-Connection -ComputerName "alianza.com" -Count 2

Write-Host ""
Write-Host "Pinging Disney.com..." -ForegroundColor Blue
Test-Connection -ComputerName "disney.com" -Count 2

Write-Host ""
Write-Host "Testing DNS resolution for all sites..." -ForegroundColor Gray

Write-Host "Google.com resolves to:" -ForegroundColor Red
Resolve-DnsName -Name "google.com"

Write-Host ""
Write-Host "Alianza.com resolves to:" -ForegroundColor Green
Resolve-DnsName -Name "alianza.com"

Write-Host ""
Write-Host "Disney.com resolves to:" -ForegroundColor Blue
Resolve-DnsName -Name "disney.com"

Write-Host ""
Write-Host "Press ENTER to continue..."
Read-Host

Write-Host ""
Write-Host "Step 2: Essential Network Settings..." -ForegroundColor Cyan

# Get all IP Addresses with labels
$ipConfigs = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*"}
foreach ($ip in $ipConfigs) {
    $adapterName = (Get-NetAdapter -InterfaceIndex $ip.InterfaceIndex).Name
    Write-Host "IP Address ($adapterName): $($ip.IPAddress)"
}

# Get Default Gateway  
$gateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1
Write-Host "Gateway: $($gateway.NextHop)"

# Get DNS Servers
$dnsServers = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.ServerAddresses -ne $null}
Write-Host "DNS Servers: $($dnsServers.ServerAddresses -join ', ')"

Write-Host ""
Write-Host "Press ENTER to continue..."
Read-Host

Write-Host ""
Write-Host "Step 3: System Information..." -ForegroundColor Cyan
Write-Host "Computer Name: $env:COMPUTERNAME"
Write-Host "Current User: $env:USERNAME"
Write-Host "Current Time: $(Get-Date)"
Write-Host "Serial Number: $((Get-WmiObject -Class Win32_BIOS).SerialNumber)"

# Get memory in GB
$memory = Get-WmiObject -Class Win32_ComputerSystem
$memoryGB = [math]::Round($memory.TotalPhysicalMemory / 1GB, 2)
Write-Host "Total RAM: $memoryGB GB"

# Get processor information
$processor = Get-WmiObject -Class Win32_Processor | Select-Object -First 1
Write-Host "Processor: $($processor.Name)"

# Get video card information (include all graphics)
$videoCards = Get-WmiObject -Class Win32_VideoController
foreach ($card in $videoCards) {
    Write-Host "Video Card: $($card.Name)"
}

# Get total storage in GB
$disks = Get-WmiObject -Class Win32_LogicalDisk
$totalStorageGB = 0
$totalFreeGB = 0
foreach ($disk in $disks) {
    $diskSizeGB = [math]::Round($disk.Size / 1GB, 2)
    $diskFreeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $totalStorageGB += $diskSizeGB
    $totalFreeGB += $diskFreeGB
    
    # Get drive label/name if it exists
    if ($disk.VolumeName -and $disk.VolumeName.Trim() -ne "") {
        Write-Host "Drive $($disk.DeviceID) ($($disk.VolumeName)) Total: $diskSizeGB GB | Available: $diskFreeGB GB"
    } else {
        Write-Host "Drive $($disk.DeviceID) Total: $diskSizeGB GB | Available: $diskFreeGB GB"
    }
}

# Only show totals if there are multiple drives
if ($disks.Count -gt 1) {
    Write-Host "Total Storage (All Drives): $totalStorageGB GB"
    Write-Host "Total Available (All Drives): $totalFreeGB GB"
}

systeminfo | findstr /C:"OS Name"

Write-Host ""
Write-Host "Done! Press ENTER to exit..."
Read-Host