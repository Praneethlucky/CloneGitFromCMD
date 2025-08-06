@echo off
set /p BASE= Enter Git Base Location


set /p TARGET= Enter Path to clone all Repositories:

:: Enable delayed expansion so we can build the FAIL list on the fly
setlocal enableDelayedExpansion

echo off
setlocal enabledelayedexpansion

:: Get the directory of the current script
set "SCRIPT_DIR=%~dp0"

:: Initialize an empty variable
set "REPOLIST="

set "ExistingRepos="



for /f "usebackq delims=" %%A in ("%SCRIPT_DIR%repos.txt") do (
    if exist "%TARGET%\%%A\.git" (
        set "ExistingRepos=!ExistingRepos! %%A"
    ) else (
        set "REPOLIST=!REPOLIST! %%A"
    )
)
:: This variable will accumulate failures
set "FAILLIST="
:: Display clone list
echo.
echo ** CLONED LIST **
echo.
for %%R in (!REPOLIST!) do (
    git clone "%BASE%/%%R.git" "%TARGET%\%%R"
    if errorlevel 1 (
        echo * FAILED to clone %%R *
        set "FAILLIST=!FAILLIST! %%R"
    ) else (
        echo Cloned successfully  -- %%R.
    )
)

:: Display existing repos
echo.
echo *** Below List Already Exists in the Target Folder ****
echo.
for %%R in (!ExistingRepos!) do (
    echo Repo already exists, skipped --- %%R.
)
echo.



::------------------  FINAL REPORT  -------------------
echo ===================================================
if defined FAILLIST (
    echo   The following repositories DID NOT clone:
    for %%F in (!FAILLIST!) do echo     - %%F
    echo(
    echo   Completed with ERRORS.
    exit /b 1
) else (
    echo   All repositories cloned successfully.
    exit /b 0
)
