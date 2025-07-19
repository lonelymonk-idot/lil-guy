@echo off
title Smile Guy Launcher
echo Hi this is beta by Lone! Friend L_22_. for recommendations and suggestions.
echo.
echo.
echo As of currently, this script is a work in progress and may not function as expected.
echo It is a simple script to demonstrate the idea of launching a sentient AI like terminal.
echo This was made for fun and IS real AI (still free and in development)
echo.
echo.
echo This script is a work in progress and may not function as expected.
echo.
echo Please report any issues to the developer. @L_22_. on discord.
echo.
echo Upon clicking any key it will open a powershell prompt than run the script.
echo.
pause
@echo off
echo Launching lil' guy...
timeout /t 2 >nul
chcp 65001 >nul
@echo off
echo in 2 seconds, lil' guy will launch and a .json memory file will be created unless already made. (DO NOT DELETE OR YOU WILL LOSE MEMORY ON THE FAKE AI)
timeout /t 2 >nul
powershell -ExecutionPolicy Bypass -NoExit -File "%~dp0SmileGuy.ps1"
pause
