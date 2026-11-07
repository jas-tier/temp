# diag_windows.ps1 - Read-only diagnostic for running a Home Assistant VM on Windows.
#
# Policy:
#   - Changes nothing (no settings, no writes, no network sends).
#   - Does not print serial numbers, UUIDs, host/user names, MAC addresses, IP addresses or SSIDs.
#   - Output goes to the screen only. To save it, redirect when you run it:
#       powershell -NoProfile -ExecutionPolicy Bypass -File .\diag_windows.ps1 > $HOME\Desktop\diag_windows.txt
#     (-ExecutionPolicy Bypass applies to this one process only. Read the script first if you prefer.)
#
# Note: This file is ASCII only on purpose (Windows PowerShell 5.1 may misread UTF-8 without a BOM).
# Note: The author could not run PowerShell, so this script is UNTESTED. If a section prints an error,
#       tell Claude which section it was.

$ErrorActionPreference = 'SilentlyContinue'

function Section($title) {
    Write-Output ''
    Write-Output "=== $title ==="
}

Write-Output 'Diagnostic script: Windows (read-only)'
Write-Output ("Run time (UTC): " + (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm'))

Section '1. OS'
$os = Get-CimInstance Win32_OperatingSystem
if ($os) {
    Write-Output ("Caption: " + $os.Caption)
    Write-Output ("Version: " + $os.Version + "  Build: " + $os.BuildNumber + "  Arch: " + $os.OSArchitecture)
    $uptime = (Get-Date) - $os.LastBootUpTime
    Write-Output ("Uptime (days): " + [math]::Round($uptime.TotalDays, 1))
} else {
    Write-Output '(could not read OS information)'
}

Section '2. CPU / RAM / GPU'
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
if ($cpu) {
    Write-Output ("CPU: " + $cpu.Name)
    Write-Output ("Cores: " + $cpu.NumberOfCores + "  Logical: " + $cpu.NumberOfLogicalProcessors)
    Write-Output ("VirtualizationFirmwareEnabled: " + $cpu.VirtualizationFirmwareEnabled)
}
$cs = Get-CimInstance Win32_ComputerSystem
if ($cs) {
    Write-Output ("RAM (GB): " + [math]::Round($cs.TotalPhysicalMemory / 1GB, 1))
    Write-Output ("HypervisorPresent: " + $cs.HypervisorPresent)
}
Get-CimInstance Win32_VideoController | ForEach-Object { Write-Output ("GPU: " + $_.Name) }

Section '3. Virtualization (Hyper-V / VBS)'
try {
    $dg = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace 'root\Microsoft\Windows\DeviceGuard' -ErrorAction Stop
    Write-Output ("VirtualizationBasedSecurityStatus (0=off, 1=enabled/not running, 2=running): " + $dg.VirtualizationBasedSecurityStatus)
    Write-Output ("SecurityServicesRunning: " + ($dg.SecurityServicesRunning -join ','))
} catch {
    Write-Output '(could not read Device Guard / VBS status)'
}
try {
    $hv = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction Stop
    Write-Output ("Hyper-V feature state: " + $hv.State)
} catch {
    Write-Output '(Hyper-V feature state: unavailable - this may need an administrator prompt, or the edition lacks Hyper-V)'
}

Section '4. Disks (fixed volumes; labels are not printed)'
Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' -and $_.DriveLetter } | ForEach-Object {
    Write-Output ("Drive " + $_.DriveLetter + ": total " + [math]::Round($_.Size / 1GB, 0) + " GB, free " + [math]::Round($_.SizeRemaining / 1GB, 0) + " GB")
}

Section '5. Network (adapter type only; no addresses)'
$route = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric | Select-Object -First 1
if ($route) { Write-Output ("Default route adapter alias: " + $route.InterfaceAlias) }
Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | ForEach-Object {
    Write-Output ("Adapter: " + $_.Name + " | " + $_.InterfaceDescription + " | " + $_.LinkSpeed + " | " + $_.PhysicalMediaType)
}

Section '6. Power and sleep (matters for always-on use)'
Write-Output ((powercfg /getactivescheme) -join ' ')
Write-Output '-- Idle sleep timeout (seconds; 0 = never) --'
powercfg /query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE | Select-String 'Index'
Write-Output '-- Available sleep states --'
powercfg /a

Section '7. Pending reboot and virtualization software (names only)'
Write-Output ("Windows Update reboot pending: " + (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'))
$paths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
$found = Get-ItemProperty $paths | Where-Object { $_.DisplayName -match 'VirtualBox|VMware|Docker|Hyper-V' } | Select-Object -ExpandProperty DisplayName
if ($found) { $found | ForEach-Object { Write-Output ("Installed: " + $_) } } else { Write-Output 'Installed: (none of VirtualBox / VMware / Docker found)' }

Write-Output ''
Write-Output '=== End ==='
Write-Output 'This script changed nothing.'
