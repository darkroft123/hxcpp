setlocal enabledelayedexpansion
@if exist "%HXCPP_MSVC%\..\..\VC\" (
	@if not exist "%HXCPP_MSVC%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat" (
		@echo Error: the specified MSVC version does not have vcvarsx86_amd64.bat setup script
	) else (
		@echo "%HXCPP_MSVC%"
		@call "%HXCPP_MSVC%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
		@echo HXCPP_VARS
		@set
	)
		exit
)
@call :hx_manual_msvc_setup x64
@if not errorlevel 1 exit
@if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
	for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
		@set InstallDir=%%i
	)
	@if exist "!InstallDir!\Common7\Tools\VsDevCmd.bat" (
		@call "!InstallDir!\Common7\Tools\VsDevCmd.bat" -arch=amd64 -app_platform=Desktop -no_logo
		@echo HXCPP_VARS
		@set
		exit
	) else (
		echo Warning: Could not find Visual Studio VsDevCmd
	)
)
@if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" (
	@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" -arch=amd64 -app_platform=Desktop -no_logo
	@echo HXCPP_VARS
	@set
) else if exist "%VS140COMNTOOLS%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat" (
	@echo "%VS140COMNTOOLS%"
	@call "%VS140COMNTOOLS%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
	@echo HXCPP_VARS
	@set
	@echo HXCPP_HACK_PDBSRV=1
) else if exist "%VS120COMNTOOLS%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat" (
	@echo "%VS120COMNTOOLS%"
	@call "%VS120COMNTOOLS%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
	@echo HXCPP_VARS
	@set
) else if exist "%VS110COMNTOOLS%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat" (
	@echo "%VS110COMNTOOLS%"
	@call "%VS110COMNTOOLS%\..\..\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
	@echo HXCPP_VARS
	@set
) else (
	echo Error: 64bit is not automatically supported for this version of VC. Set HXCPP_MSVC_CUSTOM and manually configure the executable, library and include paths
)

@goto :eof

:hx_manual_msvc_setup
@set "HXCPP_ARCH=%~1"
@set "InstallDir="
@if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
	for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -property installationPath`) do @set "InstallDir=%%i"
)
@if not defined InstallDir if exist "%ProgramFiles%\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat" @set "InstallDir=%ProgramFiles%\Microsoft Visual Studio\18\Community"
@if not defined InstallDir exit /b 1
@set "VCToolsVer="
@for /f "usebackq delims=" %%d in (`dir /b /ad /o-n "!InstallDir!\VC\Tools\MSVC" 2^>nul`) do (
	@if not defined VCToolsVer if exist "!InstallDir!\VC\Tools\MSVC\%%d\bin\HostX64\%HXCPP_ARCH%\cl.exe" @set "VCToolsVer=%%d"
)
@if not defined VCToolsVer exit /b 1
@set "VCToolsInstallDir=!InstallDir!\VC\Tools\MSVC\!VCToolsVer!"
@set "VCINSTALLDIR=!InstallDir!\VC\"
@set "SDKVER="
@for /f "usebackq delims=" %%d in (`dir /b /ad /o-n "%ProgramFiles(x86)%\Windows Kits\10\Include" 2^>nul`) do (
	@if not defined SDKVER if exist "%ProgramFiles(x86)%\Windows Kits\10\Lib\%%d\um\%HXCPP_ARCH%\kernel32.lib" @set "SDKVER=%%d"
)
@if not defined SDKVER exit /b 1
@set "WindowsSdkDir=%ProgramFiles(x86)%\Windows Kits\10\"
@set "WindowsSDKVersion=!SDKVER!\"
@set "PATH=!VCToolsInstallDir!\bin\HostX64\%HXCPP_ARCH%;%ProgramFiles(x86)%\Windows Kits\10\bin\!SDKVER!\x64;!PATH!"
@set "INCLUDE=!VCToolsInstallDir!\include;%ProgramFiles(x86)%\Windows Kits\10\Include\!SDKVER!\ucrt;%ProgramFiles(x86)%\Windows Kits\10\Include\!SDKVER!\shared;%ProgramFiles(x86)%\Windows Kits\10\Include\!SDKVER!\um;%ProgramFiles(x86)%\Windows Kits\10\Include\!SDKVER!\winrt;%ProgramFiles(x86)%\Windows Kits\10\Include\!SDKVER!\cppwinrt"
@set "LIB=!VCToolsInstallDir!\lib\%HXCPP_ARCH%;%ProgramFiles(x86)%\Windows Kits\10\Lib\!SDKVER!\ucrt\%HXCPP_ARCH%;%ProgramFiles(x86)%\Windows Kits\10\Lib\!SDKVER!\um\%HXCPP_ARCH%"
@set "LIBPATH=%LIB%"
@echo HXCPP_VARS
@set
exit /b 0