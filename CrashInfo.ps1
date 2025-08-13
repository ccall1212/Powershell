# Windows Event Log Crash Analyzer
# Helps find system crashes, kernel errors, and application crashes

Write-Host "=== Windows Crash Log Analyzer ===" -ForegroundColor Cyan
Write-Host "This will help you find crashes and errors on your computer." -ForegroundColor White
Write-Host ""

Write-Host "Choose time range to search for crashes:" -ForegroundColor Yellow
Write-Host "1. Last 30 minutes" -ForegroundColor White
Write-Host "2. Last hour" -ForegroundColor White
Write-Host "3. Last 24 hours" -ForegroundColor White
Write-Host "4. Last week" -ForegroundColor White
Write-Host "5. Last 30 days" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-5)"

# Set the time range based on user choice
switch ($choice) {
    "1" { 
        $timeRange = (Get-Date).AddMinutes(-30)
        $rangeDescription = "last 30 minutes"
    }
    "2" { 
        $timeRange = (Get-Date).AddHours(-1)
        $rangeDescription = "last hour"
    }
    "3" { 
        $timeRange = (Get-Date).AddDays(-1)
        $rangeDescription = "last 24 hours"
    }
    "4" { 
        $timeRange = (Get-Date).AddDays(-7)
        $rangeDescription = "last week"
    }
    "5" { 
        $timeRange = (Get-Date).AddDays(-30)
        $rangeDescription = "last 30 days"
    }
    default { 
        $timeRange = (Get-Date).AddDays(-7)
        $rangeDescription = "last week (default)"
        Write-Host "Invalid choice, using default: last week" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Searching for crashes in the $rangeDescription..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 1: Recent System Crashes and Critical Errors..." -ForegroundColor Yellow
Write-Host "Looking for blue screens, kernel errors, and system crashes..." -ForegroundColor Gray
Write-Host ""

# Get system crashes and critical errors from the selected time range
$systemErrors = Get-EventLog -LogName System -EntryType Error -After $timeRange | 
    Where-Object {$_.Source -like "*Kernel*" -or $_.Source -like "*BugCheck*" -or $_.EventID -eq 41 -or $_.EventID -eq 1001} |
    Select-Object TimeGenerated, Source, EventID, Message -First 10

if ($systemErrors) {
    Write-Host "Found system crashes/errors:" -ForegroundColor Red
    foreach ($error in $systemErrors) {
        Write-Host "Date: $($error.TimeGenerated)" -ForegroundColor White
        Write-Host "Source: $($error.Source)" -ForegroundColor White
        Write-Host "Event ID: $($error.EventID)" -ForegroundColor White
        Write-Host "Message: $($error.Message.Substring(0, [Math]::Min(200, $error.Message.Length)))" -ForegroundColor Gray
        Write-Host "---" -ForegroundColor DarkGray
    }
} else {
    Write-Host "No recent system crashes found (that's good!)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Press ENTER to continue to application crashes..."
Read-Host

Write-Host ""
Write-Host "Step 2: Application Crashes and Game Crashes..." -ForegroundColor Yellow
Write-Host "Looking for applications that have crashed recently..." -ForegroundColor Gray
Write-Host ""

# Get application crashes from the selected time range
$appCrashes = Get-EventLog -LogName Application -EntryType Error -After $timeRange | 
    Where-Object {$_.Source -eq "Application Error" -or $_.Source -eq "Windows Error Reporting" -or $_.Message -like "*crash*" -or $_.Message -like "*fault*"} |
    Select-Object TimeGenerated, Source, Message

if ($appCrashes) {
    $totalCount = $appCrashes.Count
    Write-Host "Found $totalCount application crashes" -ForegroundColor Red
    
    # If more than 20 results, offer export option
    if ($totalCount -gt 20) {
        Write-Host "That's a lot of crashes! Options:" -ForegroundColor Yellow
        Write-Host "1. View first 5 results (can see more after)" -ForegroundColor White
        Write-Host "2. Export all results to Desktop file" -ForegroundColor White
        $exportChoice = Read-Host "Enter choice (1 or 2)"
        
        if ($exportChoice -eq "2") {
            try {
                # Try different locations for the export file
                $desktopPath = [Environment]::GetFolderPath("Desktop")
                $fileName = "ApplicationCrashes_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
                $exportFile = Join-Path $desktopPath $fileName
                
                # Test if we can write to desktop, if not use Documents
                if (-not (Test-Path $desktopPath -PathType Container)) {
                    $documentsPath = [Environment]::GetFolderPath("MyDocuments")
                    $exportFile = Join-Path $documentsPath $fileName
                }
                
                Write-Host "Attempting to save to: $exportFile" -ForegroundColor Gray
                
                # Create the content as a string first
                $exportContent = @()
                $exportContent += "Application Crashes - $rangeDescription"
                $exportContent += "=" * 60
                $exportContent += "Total found: $totalCount crashes"
                $exportContent += ""
                
                foreach ($crash in $appCrashes) {
                    $exportContent += "Date: $($crash.TimeGenerated)"
                    $exportContent += "Source: $($crash.Source)"
                    
                    # Try to extract application name from message
                    if ($crash.Message -match "Faulting application name: ([^,]+)") {
                        $exportContent += "Application: $($matches[1])"
                    }
                    
                    $exportContent += "Message: $($crash.Message)"
                    $exportContent += "-" * 40
                }
                
                # Write all content at once
                $exportContent | Out-File -FilePath $exportFile -Encoding UTF8 -Force
                
                Write-Host "Results exported successfully to: $exportFile" -ForegroundColor Green
                Write-Host "You can copy this file content to an AI chatbot for analysis!" -ForegroundColor Cyan
            }
            catch {
                Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
                Write-Host "Falling back to screen display..." -ForegroundColor Yellow
                $exportChoice = "1"  # Fall back to showing on screen
            }
        }
    }
    
    # Show results in groups of 5 if not exported
    if ($totalCount -le 20 -or $exportChoice -ne "2") {
        $currentIndex = 0
        $batchSize = 5
        
        do {
            $batch = $appCrashes | Select-Object -Skip $currentIndex -First $batchSize
            
            foreach ($crash in $batch) {
                Write-Host "Date: $($crash.TimeGenerated)" -ForegroundColor White
                Write-Host "Source: $($crash.Source)" -ForegroundColor White
                
                # Try to extract application name from message
                if ($crash.Message -match "Faulting application name: ([^,]+)") {
                    Write-Host "Application: $($matches[1])" -ForegroundColor Yellow
                }
                
                Write-Host "Message: $($crash.Message.Substring(0, [Math]::Min(300, $crash.Message.Length)))" -ForegroundColor Gray
                Write-Host "---" -ForegroundColor DarkGray
            }
            
            $currentIndex += $batchSize
            $remaining = $totalCount - $currentIndex
            
            if ($remaining -gt 0) {
                Write-Host "Showing $currentIndex of $totalCount crashes. $remaining remaining." -ForegroundColor Yellow
                $continue = Read-Host "Press ENTER to see next 5, or type 'stop' to skip to next step"
                if ($continue -eq "stop") { break }
                Write-Host ""
            }
            
        } while ($currentIndex -lt $totalCount)
    }
} else {
    Write-Host "No recent application crashes found!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Press ENTER to continue to memory and hardware errors..."
Read-Host

Write-Host ""
Write-Host "Step 3: Memory and Hardware Errors..." -ForegroundColor Yellow
Write-Host "Looking for hardware-related issues..." -ForegroundColor Gray
Write-Host ""

# Get hardware/memory errors
$hwErrors = Get-EventLog -LogName System -EntryType Error -After $timeRange | 
    Where-Object {$_.Source -like "*Memory*" -or $_.Source -like "*Hardware*" -or $_.Source -like "*Disk*" -or $_.Source -like "*USB*"} |
    Select-Object TimeGenerated, Source, EventID, Message

if ($hwErrors) {
    $totalCount = $hwErrors.Count
    Write-Host "Found $totalCount hardware/memory errors" -ForegroundColor Red
    
    # If more than 20 results, offer export option
    if ($totalCount -gt 20) {
        Write-Host "That's a lot of hardware errors! Options:" -ForegroundColor Yellow
        Write-Host "1. View first 5 results (can see more after)" -ForegroundColor White
        Write-Host "2. Export all results to Desktop file" -ForegroundColor White
        $exportChoice = Read-Host "Enter choice (1 or 2)"
        
        if ($exportChoice -eq "2") {
            try {
                $exportFile = "$env:USERPROFILE\Desktop\HardwareErrors_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
                
                # Create the content as a string first
                $exportContent = @()
                $exportContent += "Hardware and Memory Errors - $rangeDescription"
                $exportContent += "=" * 60
                $exportContent += "Total found: $totalCount errors"
                $exportContent += ""
                
                foreach ($hwError in $hwErrors) {
                    $exportContent += "Date: $($hwError.TimeGenerated)"
                    $exportContent += "Source: $($hwError.Source)"
                    $exportContent += "Event ID: $($hwError.EventID)"
                    $exportContent += "Message: $($hwError.Message)"
                    $exportContent += "-" * 40
                }
                
                # Write all content at once
                $exportContent | Out-File -FilePath $exportFile -Encoding UTF8
                
                Write-Host "Results exported to: $exportFile" -ForegroundColor Green
                Write-Host "You can copy this file content to an AI chatbot for analysis!" -ForegroundColor Cyan
            }
            catch {
                Write-Host "Error creating export file. Showing results on screen instead." -ForegroundColor Red
                $exportChoice = "1"  # Fall back to showing on screen
            }
        }
    }
    
    # Show results in groups of 5 if not exported
    if ($totalCount -le 20 -or $exportChoice -ne "2") {
        $currentIndex = 0
        $batchSize = 5
        
        do {
            $batch = $hwErrors | Select-Object -Skip $currentIndex -First $batchSize
            
            foreach ($hwError in $batch) {
                Write-Host "Date: $($hwError.TimeGenerated)" -ForegroundColor White
                Write-Host "Source: $($hwError.Source)" -ForegroundColor White
                Write-Host "Event ID: $($hwError.EventID)" -ForegroundColor White
                Write-Host "Message: $($hwError.Message.Substring(0, [Math]::Min(200, $hwError.Message.Length)))" -ForegroundColor Gray
                Write-Host "---" -ForegroundColor DarkGray
            }
            
            $currentIndex += $batchSize
            $remaining = $totalCount - $currentIndex
            
            if ($remaining -gt 0) {
                Write-Host "Showing $currentIndex of $totalCount errors. $remaining remaining." -ForegroundColor Yellow
                $continue = Read-Host "Press ENTER to see next 5, or type 'stop' to skip to completion"
                if ($continue -eq "stop") { break }
                Write-Host ""
            }
            
        } while ($currentIndex -lt $totalCount)
    }
} else {
    Write-Host "No hardware errors found (that's good!)" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Log Analysis Complete ===" -ForegroundColor Cyan
Write-Host "Press ENTER to exit..."
Read-Host