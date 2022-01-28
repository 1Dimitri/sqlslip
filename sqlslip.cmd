:: SQL Server 2019 Adding CU in a RTM Distribution and create ISOs

@echo off
if "%3"=="" goto :usage
if errorlevel 9009 echo OSCDIMG.EXE was not found, ISO will not be created, please add /noiso

setlocal
set mediasource=%1
set mediacopy=%~dpn3
if exist %mediacopy% ( echo deleting %mediacopy% && rd %mediacopy% /s /q) 
echo Copying %mediasource% (R/O) to %mediacopy%
robocopy %mediasource% %mediacopy% /E /COPY:DT
set tempcu=%mediacopy%\cu
for %%i in (%2\*.exe) do (echo Extracting %%i to %tempcu% && %%i /x:%tempcu% /q )

for %%i in (x64) do (
Echo creating/adding to defaultsetup.ini if necessary in %%i
if not exist %mediacopy%\%%i\defaultsetup.ini [OPTIONS]>%mediacopy%\%%i\defaultsetup.ini
attrib -r %mediacopy%\%%i\defaultsetup.ini
echo CUSOURCE=".\CU">>%mediacopy%\%%i\defaultsetup.ini
)
Echo creating ISO from %mediacopy% into %3
set label=%~n2
if /I "%4"=="/noiso" goto :noiso
if /I "%5"=="/noiso" goto :noiso

oscdimg -o -l%label% -u2 %mediacopy% %3
:noiso

if /I "%4"=="/nocleanup" goto :nocleanup
if /I "%5"=="/nocleanup" goto :nocleanup

rd %mediacopy% /s /q
goto :theend
:nocleanup
echo No cleanup made. Intermediate files in %mediacopy%
:theend
endlocal
goto :eof
:usage
echo %~n0 SQLSource-Directory CU-Directory TargetDirectory [/nocleanup] [/noiso] 
:: echo SQLSource-Directory will be modified, so make a copy of the RTM distribution before applying this batch!
echo e.g.
echo %~nx0 E:\ C:\CU14 D:\Temp\SQLSERVER2019CU14.ISO
echo.
echo E:\ is a read-only source for the RTM version of SQL Server (e.g. mounted ISO)
echo C:\CU14 is the location of the *untouched* KB exe of the CU 
echo    CU14 will be then the label of the ISO, so you may want to name the directory like SQL2019CU14 instead.
echo D:\temp\SQLSERVER2019CU14 side-by-side with the iso will be a temporary directory which will be erased afterwards
echo   /nocleanup will not remove  D:\temp\SQLSERVER2019CU14  
echo   /noiso builds the structure and not the ISO
echo. 
echo the build of the iso requires ISOCDIMG.EXE in the path
