@echo off
setlocal EnableDelayedExpansion

:: Wazuh Active Response Script: Automated Malware File Containment (Windows)
:: Location on Agent: C:\Program Files (x86)\ossec-agent\active-response\bin\remove-threat.cmd

set /p INPUT_JSON=

:: Extract file path using PowerShell
for /f "usebackq delims=" %%A in (`powershell -Command "$json = '%INPUT_JSON%' | ConvertFrom-Json; $json.parameters.alert.syscheck.path"`) do (
    set TARGET_FILE=%%A
)

if exist "!TARGET_FILE!" (
    del /f /q "!TARGET_FILE!"
    echo File !TARGET_FILE! quarantined successfully. >> "C:\Program Files (x86)\ossec-agent\active-response\active-responses.log"
)
exit /b 0
