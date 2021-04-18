@echo off
SETLOCAL

:MENU
cd bin64
ECHO.
ECHO                            MAIN MENU
ECHO ...................................................................
ECHO Type the number coresponding to what you wish do to and press ENTER
ECHO ...................................................................
ECHO.
ECHO 1 - Update/Install Both (ArcDPS+d912pxy)
ECHO 2 - Update/Install ArcDPS
ECHO 3 - Update/Install d912pxy
ECHO 4 - I'm having issues! (troubleshooting menu)
ECHO 0 - EXIT
ECHO.
SET /P M=Input: 
IF %M%==1 GOTO QUICK
IF %M%==2 GOTO ARC
IF %M%==3 GOTO PXY
IF %M%==4 GOTO TROUBLE
IF %M%==0 GOTO EOF

:QUICK
GOTO PXY

:ARC
IF NOT %M%==1 (
echo Deleting old backup...
del /f d3d9.dll.bak
echo Backing up current ArcDPS...
rename d3d9.dll d3d9.dll.bak
)
echo Downloading new ArcDPS...
powershell -Command "Invoke-WebRequest https://www.deltaconnected.com/arcdps/x64/d3d9.dll -OutFile d3d9.dll"
echo Done!
GOTO MENU

:PXY
echo Deleting old backup...
del /f d3d9_chainload.dll.bak
echo Backing up current d912pxy dll...
del /f d3d9.dll.bak
del /f d3d9_chainload.dll.bak
rename d3d9.dll d3d9.dll.bak
rename d3d9_chainload.dll d3d9_chainload.dll.bak
echo Cleaning up anything that needs to be...
cd ..
rmdir /s /q tmp
rmdir /s /q d912pxy.bak
echo Making d912pxy backup folder...
mkdir d912pxy.bak
echo Copying all contents of d912pxy folder to d912pxy backup folder...
xcopy.exe /s /y d912pxy d912pxy.bak
echo Making temporary working directory...
mkdir tmp
cd ./tmp/
echo Downloading and extracting d912pxy...
powershell -Command "$response = Invoke-WebRequest https://api.github.com/repos/megai2/d912pxy/releases/latest; $json = $response.Content | ConvertFrom-Json; $url = $json.assets[0].browser_download_Url; Invoke-WebRequest $url -OutFile d912pxy.zip; Expand-Archive d912pxy.zip -DestinationPath ./"
del /f d912pxy.zip
cd ..
echo Copying extracted files...
xcopy.exe /s /y /i "%cd%/tmp/d912pxy" "%cd%/d912pxy"
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
cd d912pxy/dll/release && xcopy /s /y d3d9.dll "%cd%/bin64/d3d9.dll*" & cd ../../../bin64
GOTO MENU

:PXYARC
cd d912pxy/dll/release && xcopy /s /y d3d9.dll "%cd%/bin64/d3d9_chainload.dll*" & cd ../../../bin64
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
del /f "d3d9.dll.bak"
del /f "d3d9_chainload.dll.bak"
xcopy /s /y d3d9.dll d3d9.dll.bak
xcopy /s /y d3d9_chainload.dll d3d9_chainload.dll.bak
del /f "d3d9.dll"
del /f "d3d9_chainload.dll"
del /f "d3d9.dll.disabled"
del /f "d3d9_chainload.dll.disabled"
GOTO TROUBLE

:REMOVEADDON
ECHO.
ECHO Are you sure you want to remove all your addons?
ECHO.
ECHO Literally anyhting = No
ECHO 0 = Yes
SET /P N=Input: 
IF %N%==0 GOTO REMOVEADDONCONFIRM
GOTO TROUBLE

:REMOVEADDONCONFIRM
del /f "d3d9.dll.bak"
del /f "d3d9_chainload.dll.bak"
del /f "d3d9.dll"
del /f "d3d9_chainload.dll"
del /f "d3d9.dll.disabled"
del /f "d3d9_chainload.dll.disabled"
cd..
rmdir /s /q d912pxy
cd bin64
GOTO MENU

:EOF
cd ..
ENDLOCAL
