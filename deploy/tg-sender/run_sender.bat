@echo off
rem Starts the tg-sender service (used by Task Scheduler at system startup)
cd /d "%~dp0"
python sender.py serve >> sender_console.log 2>&1
