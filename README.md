# PowerShell Network & System Checker

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
