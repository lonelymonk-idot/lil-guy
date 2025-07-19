@echo off
title Smile Guy Launcher
echo Hi this is beta by Lone! Friend L_22_. for recommendations and suggestions.
echo.
echo.
echo This script so far includes: hi! are you actually sentient, i hate you, i love you, youre dumb, stupid, why do you exist, and type exit to exit the prompt.
echo.
echo This script is a work in progress and may not function as expected.
echo.
echo Please report any issues to the developer.
echo.
echo Upon clicking Enter it will launch
pause
color 0A
chcp 65001 >nul
powershell -ExecutionPolicy Bypass -NoExit -File "%~dp0SmileGuy.ps1"
pause
