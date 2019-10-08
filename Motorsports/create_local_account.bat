@ECHO OFF
TITLE Add local account
SET username=student
SET password=guessthis02
net user %username% %password% /add
pause
