# **ComputerInfo.ps1**

## Description
An interactive PowerShell script that performs comprehensive network connectivity tests and displays detailed system information. Perfect for troubleshooting network issues or getting a quick overview of your computer's status.

## Features

### Network Testing
- **Multi-site connectivity test**: Pings Google.com, Alianza.com, and Disney.com (2 pings each)
- **DNS resolution test**: Shows IP addresses for all tested websites
- **Network configuration**: Displays IP addresses (labeled by adapter), gateway, and DNS servers
- **Color-coded output**: Each website has its own color (Red, Green, Blue) for easy identification

### System Information
- Computer name and current user
- Current date and time
- System serial number
- Total RAM (displayed in GB)
- Processor information
- Video card details (including integrated graphics)
- Storage information per drive with available space
- Operating system details

### User Experience
- **Interactive**: Pauses between each step, press Enter to continue
- **Clean output**: Only shows essential information, no clutter
- **Smart storage display**: Shows totals only when multiple drives are present
- **Drive labels**: Displays custom drive names (e.g., "My Documents") when available

## Usage
1. Save the script as `NetworkChecker.ps1`
2. Run in PowerShell: `.\NetworkChecker.ps1`
3. Follow the prompts, pressing Enter to advance through each step

## Requirements
- Windows PowerShell
- Standard Windows networking commands
- No additional modules required

## What You'll See
- **Step 1**: Network connectivity and DNS tests for multiple websites
- **Step 2**: Essential network configuration (IP, gateway, DNS)
- **Step 3**: Complete system hardware and storage overview

Perfect for IT troubleshooting, system inventory, or daily network health checks.

---------------------------------------------------------------------------------------

# **Crashinfo.ps1**

## Description
A comprehensive PowerShell script that analyzes Windows Event Logs to identify system crashes, application failures, and hardware errors. Designed to help troubleshoot computer stability issues and track down the root causes of crashes and blue screens.

## Features

### Flexible Time Range Selection
- **Last 30 minutes** - For immediate crash investigation
- **Last hour** - Recent issues
- **Last 24 hours** - Today's problems
- **Last week** - General troubleshooting
- **Last 30 days** - Pattern analysis and comprehensive review

### Comprehensive Crash Detection
- **System crashes**: Kernel errors, blue screens, unexpected shutdowns
- **Application crashes**: Software failures, game crashes, service errors
- **Hardware errors**: Memory issues, disk problems, USB failures

### Smart Result Management
- **Pagination**: Shows 5 results at a time for easy reading
- **Export functionality**: Saves large result sets to Desktop files for analysis
- **Automatic fallback**: If export fails, displays results on screen
- **Progress tracking**: Shows "X of Y results" with option to continue or skip

### User Experience
- **Interactive**: Step-by-step process with user control
- **Color-coded output**: Easy identification of error types
- **Detailed information**: Timestamps, sources, event IDs, and full error messages
- **AI-friendly exports**: Text files formatted for easy copying to AI chatbots

## Usage
1. **Run as Administrator** (required for full Event Log access)
2. Save script as `CrashAnalyzer.ps1`
3. Execute: `.\CrashAnalyzer.ps1`
4. Choose your desired time range (1-5)
5. Review results step by step

## Export Features
When more than 20 results are found, the script offers:
- **View 5 at a time** with pagination controls
- **Export to Desktop file** with timestamps in filename
- **Copy-paste ready format** for AI analysis and troubleshooting

## Requirements
- Windows PowerShell
- Administrator privileges (for Event Log access)
- No additional modules required

## What You'll Discover
- Patterns in crash timing and frequency
- Specific applications causing instability
- Hardware-related error trends
- System service failures
- Memory and driver issues

Perfect for IT professionals, system administrators, or anyone trying to diagnose computer stability problems and identify recurring crash patterns.
