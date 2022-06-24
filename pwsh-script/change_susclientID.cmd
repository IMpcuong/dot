@echo on
net stop wuauserv
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v AccountDomainSid /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v PingID /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /f
net start wuauserv
wuauclt /resetauthorization /detectnow
Pause
..

:: wuauserv: Windows Update Service. (this is also a comment)
REM comment (~ //, # := comment character)
REM https://stackoverflow.com/questions/11269338/how-to-comment-out-add-comment-in-a-batch-cmd