@echo off

set GIT_PATH="C:\Program Files\Git\bin\git.exe"

	%GIT_PATH% pull
	%GIT_PATH% add -A
	%GIT_PATH% -c commit.gpgsign=false commit -m "Auto-committed on %date%-%time%"
	%GIT_PATH% push
