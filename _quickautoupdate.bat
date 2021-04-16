@echo off
SETLOCAL
where /q curl
IF %ERRORLEVEL% NEQ 0 (
	IF EXIST "%cd%/curl/curl-7.76.1-win64-mingw/bin/curl.exe" (
		SET CURL="%cd%/curl/curl-7.76.1-win64-mingw/bin/curl.exe"
	) ELSE (
		powershell -Command "Invoke-WebRequest https://curl.se/windows/dl-7.76.1/curl-7.76.1-win64-mingw.zip -OutFile curl.zip"
		powershell Expand-Archive curl.zip
		del /f curl.zip
		SET CURL="%cd%/curl/curl-7.76.1-win64-mingw/bin/curl.exe"
	)
) ELSE (
	SET CURL=curl
)
cd bin64
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
echo Downloading some tools...
%CURL% -Lk --output coreutils.zip --url "http://download-mirror.savannah.gnu.org/releases/coreutils/windows-64bit-unsupported/coreutils-8.31-28-windows-64bit.zip"
powershell Expand-Archive coreutils.zip -DestinationPath coreutils
del /f coreutils.zip
%CURL% -s https://api.github.com/repos/megai2/d912pxy/releases/latest \ | findstr browser_download_url | "./coreutils/coreutils-8.31-28-windows-64bit/cut.exe" -d : -f 2,3 > url.txt && set /p url=<url.txt 
SET url=%url:"=% && %CURL% -Lk --output d912pxy.zip --url %url% && del /f url.txt
rmdir /s /q coreutils
powershell Expand-Archive d912pxy.zip -DestinationPath ./
del /f d912pxy.zip
cd ..
xcopy.exe /s /y /i "%cd%/tmp/d912pxy" "%cd%/d912pxy"
rmdir /s /q tmp
cd d912pxy/dll/release && xcopy /s /y d3d9.dll "%cd%/bin64/d3d9_chainload.dll*" & cd ../../../bin64
echo Deleting old backup...
del /f d3d9.dll.bak
echo Backing up current ArcDPS...
rename d3d9.dll d3d9.dll.bak
echo Downloading new ArcDPS...
%CURL% --output d3d9.dll --url https://www.deltaconnected.com/arcdps/x64/d3d9.dll
echo Done!
cd..
ENDLOCAL
