Var bolCustomCreatedLegacy

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.2.9.9" $R0
		${If} $R0 == 2
			${If} ${FileExists} "$INSTDIR\App\Mumble\Overlay\*.*"
				Rename "$INSTDIR\App\Mumble\Overlay" "$INSTDIR\Data\Overlay"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Mumble\Plugins\*.*"
				Rename "$INSTDIR\App\Mumble\Plugins" "$INSTDIR\Data\Plugins"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Mumble\Snapshots\*.*"
				Rename "$INSTDIR\App\Mumble\Snapshots" "$INSTDIR\Data\Snapshots"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Mumble\Themes\*.*"
				Rename "$INSTDIR\App\Mumble\Themes" "$INSTDIR\Data\Themes"
			${EndIf}
		${EndIf}
	${EndIf}
	
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	ReadRegStr $1 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	
	${If} $1 < 9600 ;Windows 7/8.0
	${OrIf} $0 == 0 ;or 32-bit
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.5.634.0" $R0
		${If} $R0 = 2
			${GetParent} $INSTDIR $1
			${IfNot} ${FileExists} "$1\MumblePortableLegacy32bit\*.*"
				CreateDirectory "$1\MumblePortableLegacy32bit"
				CopyFiles /SILENT "$INSTDIR\*.*" "$1\MumblePortableLegacy32bit"
				WriteINIStr "$1\MumblePortableLegacy32bit\App\AppInfo\AppInfo.ini" "Details" "AppID" "MumblePortableLegacy32bit"
				WriteINIStr "$1\MumblePortableLegacy32bit\App\AppInfo\AppInfo.ini" "Details" "Name" "Mumble Portable (Legacy 32-bit)"
				StrCpy $bolCustomCreatedLegacy true
				WriteINIStr "$1\MumblePortableLegacy32bit\App\AppInfo\AppInfo.ini" "Control" "Start" "MumblePortableLegacy32bit.exe"
				WriteINIStr "$1\MumblePortableLegacy32bit\App\AppInfo\AppInfo.ini" "Format" "Version" "3.8"
			${EndIf}	
		${EndIf}
	${EndIf}
!macroend


!macro CustomCodePostInstall
	${If} $bolCustomCreatedLegacy == true
		${GetParent} $INSTDIR $1
		Delete "$1\MumblePortableLegacy32bit\MumblePortable.exe"
		Delete "$1\MumblePortableLegacy32bit\App\Readme.txt"
		CopyFiles /SILENT "$INSTDIR\App\Readme.txt" "$1\MumblePortableLegacy32bit\App"
		CopyFiles /SILENT "$INSTDIR\Other\Source\Legacy\MumblePortableLegacy32bit.exe" "$1\MumblePortableLegacy32bit"
		Rename "$1\MumblePortableLegacy32bit\App\AppInfo\Launcher\MumblePortable.ini" "$1\MumblePortableLegacy32bit\App\AppInfo\Launcher\MumblePortableLegacy32bit.ini"
		${If} ${FileExists} "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableSettings.ini"
			Rename "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableSettings.ini" "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableLegacy32bitSettings.ini"
			ReadINIStr $0 "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableLegacy32bitSettings.ini" "MumblePortableSettings" "LastDrive"
			WriteINIStr "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableLegacy32bitSettings.ini" "MumblePortableLegacy32bitSettings" "LastDrive" "$0"
			ReadINIStr $0 "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableLegacy32bitSettings.ini" "MumblePortableSettings" "LastDirectory"
			WriteINIStr "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableLegacy32bitSettings.ini" "MumblePortableLegacy32bitSettings" "LastDirectory" "$0"
			DeleteINISec "$1\MumblePortableLegacy32bit\Data\settings\MumblePortableLegacy32bitSettings.ini" "MumblePortableSettings"
		${EndIf}
	${EndIf}
!macroend

