@ECHO off
TITLE Traceroute for FAKS v1.0
ECHO -- Traceroute for FAKS v1.0 --
ECHO Press CTRL+C to exit.
ECHO:

SET /p room= Please enter room number:


SET host=8.8.8.8
SET maxhops=20


SET dt=%DATE:~6,4%_%DATE:~3,2%_%DATE:~0,2%__%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
SET dt=%dt: =0%
Rem outfolder must not end by \
SET outfolder=%USERPROFILE%\Desktop\traceroute
SET outfile=%outfolder%\%room%__%dt%.log

IF NOT EXIST "%outfolder%" (
  ECHO Output folder %outfolder% does not exist. Creating it.
  MKDIR "%outfolder%\"
)

echo Performing traceroute now... please wait!

tracert -h %maxhops% -4 %host% > "%outfile%"

echo:
ECHO Output file saved to: %outfile%
ECHO Program completed. Goodbye!
echo:
PAUSE
