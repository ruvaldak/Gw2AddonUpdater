@echo off
SETLOCAL

:START
cd bin64
GOTO MENU

:MENU
ECHO.
ECHO                            MAIN MENU
ECHO ...................................................................
ECHO Type the number coresponding to what you wish do to and press ENTER
ECHO ...................................................................
ECHO.
ECHO 1 - Update/Install Both (ArcDPS+d912pxy)
ECHO 2 - Update/Install ArcDPS
ECHO 3 - Update/Install d912pxy
ECHO 4 - Other addons
ECHO 5 - I'm having issues! (troubleshooting menu)
ECHO 0 - EXIT
ECHO.
SET /P M=Input: 
IF %M%==1 GOTO QUICK
IF %M%==2 GOTO ARC
IF %M%==3 GOTO PXY
IF %M%==4 GOTO EXTRA
IF %M%==5 GOTO TROUBLE
IF %M%==0 GOTO EOF

:QUICK
GOTO PXY

:ARC
echo Downloading new ArcDPS...
powershell -Command "Invoke-WebRequest https://www.deltaconnected.com/arcdps/x64/d3d9.dll -OutFile d3d9.dll"
echo Done!
GOTO MENU

:PXY
echo Cleaning up anything that needs to be...
cd ..

REM remove tmp folder if it exists
IF EXIST tmp\ rmdir /s /q tmp

REM remove d912pxy.bak folder if it exists. We'll be backing up the current one anyways.
IF EXIST d912pxy.bak\ rmdir /s /q d912pxy.bak

echo Making d912pxy backup folder...
mkdir d912pxy.bak
echo Copying all contents of d912pxy folder to d912pxy backup folder...
xcopy.exe /q /s /y d912pxy d912pxy.bak
echo Making temporary working directory...
mkdir tmp
cd ./tmp/
echo Downloading and extracting d912pxy...
powershell -Command "$response = Invoke-WebRequest https://api.github.com/repos/megai2/d912pxy/releases/latest; $json = $response.Content | ConvertFrom-Json; $url = $json.assets[0].browser_download_Url; Invoke-WebRequest $url -OutFile d912pxy.zip; Expand-Archive d912pxy.zip -DestinationPath ./"
del /f d912pxy.zip
cd ..
echo Copying extracted files...
xcopy.exe /q /s /y /i "%cd%/tmp/d912pxy" "%cd%/d912pxy"
rmdir /s /q tmp
IF %M%==1 GOTO PXYARC
ECHO.
ECHO Are you using ArcDPS?
ECHO.
ECHO 0 = No
ECHO 1 = Yes
SET /P V=Type 0 or 1 and press ENTER:
IF %V%==0 GOTO PXYSOLO
IF %V%==1 GOTO PXYARC

:PXYSOLO
IF EXIST "%cd%/bin64/d912pxy.dll" (
	cd d912pxy/dll/release && xcopy /q /s /y /i d3d9.dll "../../../bin64/d912pxy.dll*" & cd ../../../bin64
) ELSE (
	cd d912pxy/dll/release && xcopy /q /s /y /i d3d9.dll "../../../bin64/d3d9.dll*" & cd ../../../bin64
)
GOTO MENU

:PXYARC
IF EXIST "%cd%/bin64/d912pxy.dll" (
	cd d912pxy/dll/release && xcopy /q /s /y /i d3d9.dll "../../../bin64/d912pxy.dll*" & cd ../../../bin64
) ELSE (
	cd d912pxy/dll/release && xcopy /q /s /y /i d3d9.dll "../../../bin64/d3d9_chainload.dll*" & cd ../../../bin64
)
GOTO ARC

:TROUBLE
ECHO.
ECHO ....................
ECHO Troubleshooting menu
ECHO ....................
ECHO.
ECHO 1 - Enable/Disable addons
ECHO 2 - Remove addon dlls
ECHO 3 - Remove addons entirely
ECHO 4 - Return to MENU
ECHO.
SET /P K=Input: 
IF %K%==1 GOTO ENABLEDISABLE
IF %K%==2 GOTO REMOVEDLL
IF %K%==3 GOTO REMOVEADDON
IF %K%==4 GOTO MENU

:ENABLEDISABLE
for /r "%cd%" %%a in (*) do (
	if "%%~nxa"=="d3d9.dll.disabled" (
		echo Found Disabled d3d9
		set p=%%~dpnxa
		if defined p (
			rename d3d9.dll.disabled d3d9.dll
			GOTO TROUBLE
		)
	) ELSE (
		if "%%~nxa"=="d3d9.dll" (
			echo Found enabled d3d9
			set p=%%~dpnxa
			if defined p (
				rename d3d9.dll d3d9.dll.disabled
				GOTO TROUBLE
			)
		)
	)
)
GOTO TROUBLE

:REMOVEDLL
IF EXIST "d3d9.dll.bak" del /f "d3d9.dll.bak"
IF EXIST "d3d9_chainload.dll.bak" del /f "d3d9_chainload.dll.bak"
xcopy /s /y d3d9.dll d3d9.dll.bak
xcopy /s /y d3d9_chainload.dll d3d9_chainload.dll.bak
IF EXIST "d3d9.dll" del /f "d3d9.dll"
IF EXIST "d3d9_chainload.dll" del /f "d3d9_chainload.dll"
IF EXIST "d3d9.dll.disabled" del /f "d3d9.dll.disabled"
IF EXIST "d3d9_chainload.dll.disabled" del /f "d3d9_chainload.dll.disabled"
GOTO TROUBLE

:REMOVEADDON
ECHO.
ECHO Are you sure you want to remove all your addons?
ECHO.
ECHO Literally anything = No
ECHO 0 = Yes
SET /P N=Input: 
IF %N%==0 GOTO REMOVEADDONCONFIRM
GOTO TROUBLE

:REMOVEADDONCONFIRM
IF EXIST "d3d9.dll.bak" del /f "d3d9.dll.bak"
IF EXIST "d3d9_chainload.dll.bak" del /f "d3d9_chainload.dll.bak"
IF EXIST "d3d9.dll" del /f "d3d9.dll"
IF EXIST "d3d9_chainload.dll" del /f "d3d9_chainload.dll"
IF EXIST "d3d9.dll.disabled" del /f "d3d9.dll.disabled"
IF EXIST "d3d9_chainload.dll.disabled" del /f "d3d9_chainload.dll.disabled"
cd..
IF EXIST d912pxy\ rmdir /s /q d912pxy
cd bin64
GOTO MENU

:EXTRA
ECHO.
ECHO                            EXTRA ADDONS
ECHO ...................................................................
ECHO Type the number coresponding to what you wish do to and press ENTER
ECHO ...................................................................
ECHO.
ECHO 1 - GW2Radial
ECHO 0 - MAIN MENU
ECHO.
SET /P L=Input: 
IF %L%==1 GOTO RADIAL
IF %L%==0 GOTO MENU

:RADIAL
REM https://api.github.com/repos/Friendly0Fire/GW2Radial/releases/latest
cd ..
echo Cleaning anything that might need to be cleaned...
IF EXIST tmp\ rmdir /s /q tmp
echo Making temporary working directory...
mkdir tmp && cd tmp
echo Downloading and extracting files...
powershell -Command "$response = Invoke-WebRequest https://api.github.com/repos/Friendly0Fire/GW2Radial/releases/latest; $json = $response.Content | ConvertFrom-Json; $url = $json.assets[0].browser_download_Url; Invoke-WebRequest $url -OutFile gw2radial.zip; Expand-Archive gw2radial.zip -DestinationPath ./gw2radial"
del /f gw2radial.zip
cd gw2radial
GOTO RADIALCOND

:RADIALCOND
echo.
echo Do you use ArcDPS? (1=Yes; 0=No)
SET /P ARCQ=Input: 
echo.
echo Do you use d912pxy? (1=Yes; 0=No)
SET /p DXQ=Input: 
GOTO RADIALTEST

:RADIALTEST
echo Installing...
IF %ARCQ%==1 (
	IF %DXQ%==1 (
		IF NOT EXIST "%cd%/../../bin64/d912pxy.dll" rename "%cd%/../../bin64/d3d9_chainload.dll" d912pxy.dll
	)
	rename "d3d9.dll" "d3d9_chainload.dll"
	move /Y d3d9_chainload.dll "%cd%/../../bin64/"
) ELSE (
	IF %DXQ%==1 (
		IF NOT EXIST "%cd%/../../bin64/d912pxy.dll" rename "%cd%/../../bin64/d3d9.dll" d912pxy.dll
	)
	move /Y d3d9.dll "%cd%/../../bin64/"
)
GOTO RADIALCONT

:RADIALCONT
cd ../..
echo Cleaning up...
rmdir /s /q tmp
cd bin64
echo Done!
GOTO MENU

:EOF
cd ..
ENDLOCAL
