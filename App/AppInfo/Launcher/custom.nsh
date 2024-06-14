${SegmentFile}

${Segment.OnInit}
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	ReadRegStr $2 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	
	${If} $2 < 9600 ;Windows 7/8
	${OrIf} $0 == 0 ;or 32-bit 10
		StrCpy $AppName "Mumble"
		${If} ${IsWin2000}
			StrCpy $1 2000
		${ElseIf} ${IsWinXP}
			StrCpy $1 XP
		${ElseIf} ${IsWin2003}
			StrCpy $1 2003
		${ElseIf} ${IsWinVista}
			StrCpy $1 Vista
		${ElseIf} ${IsWin2008}
			StrCpy $1 2008
		${ElseIf} ${IsWin7}
			StrCpy $1 7
		${ElseIf} ${IsWin2008R2}
			StrCpy $1 "2008 R2"
		${ElseIf} ${IsWin8}
			StrCpy $1 8
		${ElseIf} ${IsWin2012}
			StrCpy $1 2012
		${Else}
			StrCpy $1 "Pre-Win 8.1 64-bit"
		${EndIf}	
		StrCpy $0 "8.1 64-bit"
		MessageBox MB_OK|MB_ICONSTOP "$(LauncherIncompatibleMinOS)"
		Abort
	${EndIf}
!macroend
