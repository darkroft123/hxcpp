setlocal enabledelayedexpansion
@if exist "%HXCPP_MSVC%\vcvars32.bat" (
	@call "%HXCPP_MSVC%\vcvars32.bat"
	@echo HXCPP_VARS
	@set
	exit
) else if exist "%HXCPP_MSVC%\vsvars32.bat" (
	@call "%HXCPP_MSVC%\vsvars32.bat"
	@echo HXCPP_VARS
	@set
	exit
)
@call :hx_manual_msvc_setup x86
@if not errorlevel 1 exit
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
	for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
		@set InstallDir=%%i
	)
	@if exist "!InstallDir!\Common7\Tools\VsDevCmd.bat" (
		@call "!InstallDir!\Common7\Tools\VsDevCmd.bat" -arch=x86 -app_platform=Desktop -no_logo
		@echo HXCPP_VARS
		@set
		exit
	) else (
		echo Warning: Could not find Visual Studio VsDevCmd
	)
)
@if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" (
	@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" -arch=x86 -app_platform=Desktop -no_logo
	@echo HXCPP_VARS
	@set
) else if exist "%VS140COMNTOOLS%\vsvars32.bat" (
	@call "%VS140COMNTOOLS%\vsvars32.bat"
	@if defined HXCPP_WINXP_COMPAT (
		@set "INCLUDE=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Include;!INCLUDE!"
		@set "PATH=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Bin;!PATH!"
		@set "LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Lib;!LIB!"
		@set HXCPP_XP_DEFINE=_USING_V140_SDK71_
	)
	@echo HXCPP_VARS
	@set
) else if exist "%VS120COMNTOOLS%\vsvars32.bat" (
	@call "%VS120COMNTOOLS%\vsvars32.bat"
	@if defined HXCPP_WINXP_COMPAT (
		@if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\" (
			@set "INCLUDE=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Include;!INCLUDE!"
			@set "PATH=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Bin;!PATH!"
			@set "LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Lib;!LIB!"		
		) else if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\" (
			@set "INCLUDE=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Include;!INCLUDE!"
			@set "PATH=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Bin;!PATH!"
			@set "LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Lib;!LIB!"
		)

		@set HXCPP_XP_DEFINE=_USING_V120_SDK71_
	)
	@echo HXCPP_VARS
	@set
) else if exist "%VS110COMNTOOLS%\vsvars32.bat" (
	@call "%VS110COMNTOOLS%\vsvars32.bat"
	@if defined HXCPP_WINXP_COMPAT (
		@set "INCLUDE=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Include;!INCLUDE!"
		@set "PATH=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Bin;!PATH!"
		@set "LIB=%ProgramFiles(x86)%\Microsoft SDKs\Windows\7.1A\Lib;!LIB!"
		@set HXCPP_XP_DEFINE=_USING_V110_SDK71_
	)
	@echo HXCPP_VARS
	@set
) else if exist "%VS100COMNTOOLS%\vsvars32.bat" (
	@call "%VS100COMNTOOLS%\vsvars32.bat"
	@echo HXCPP_VARS
	@set
) else if exist "%VS90COMNTOOLS%\vsvars32.bat" (
	@call "%VS90COMNTOOLS%\vsvars32.bat"
	@echo HXCPP_VARS
	@set
) else if exist "%VS80COMNTOOLS%\vsvars32.bat" (
	@call "%VS80COMNTOOLS%\vsvars32.bat"
	@echo HXCPP_VARS
	@set
) else if exist "%VS71COMNTOOLS%\vsvars32.bat" (
	@call "%VS71COMNTOOLS%\vsvars32.bat"
	@echo HXCPP_VARS
	@set
) else if exist "%VS70COMNTOOLS%\vsvars32.bat" (
	@call "%VS70COMNTOOLS%\vsvars32.bat"
	@echo HXCPP_VARS
	@set
) else (
	echo Warning: Could not find environment variables for Visual Studio
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
