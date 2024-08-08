@echo off
title Jenkins Agent Connected ... DO NOT CLOSE THIS WINDOW
set host=%COMPUTERNAME%
REM LOAD PROPERTIES ----------------------------------------------------------------------------
FOR /F "tokens=1,2 delims==" %%G IN (jenkins.properties) DO (set %%G=%%H)
REM --------------------------------------------------------------------------------------------

for /f "skip=4 usebackq tokens=2" %%a in (nslookup %master_name%) do ( if %%a NEQ %master_name% set IP=%%a)
echo %IP%


:loop
NetStat -na | Findstr "%IP%:%port%"| findstr "ESTABLISHED"
IF %ERRORLEVEL% equ 0 (
echo CONNECTION ALREADY ESTABLISHED.. DO NOT CLOSE THIS WINDOW...
timeout /t 300 /nobreak
goto loop
)

IF %ERRORLEVEL% equ 1 (

"%java_path%" -Dorg.jenkinsci.plugins.gitclient.Git.timeOut=1100 -jar agent.jar -jnlpUrl https://%master_name%:8443/computer/%host%/jenkins-agent.jnlp -secret 9f643cb5c7845c6c8d075a3cbd7b1676765ec24800e38ecd9fabf0fa806865cc -workDir "C:\Jenkins"
timeout /t 15 /nobreak
goto loop
)
