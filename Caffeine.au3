#NoTrayIcon
;#include <GUIConstants.au3>
#include <WinAPI.au3>
#region - AutoIt3Wrapper Directives
#AutoIt3Wrapper_Icon=caffeine.ico
#AutoIt3Wrapper_Version=P
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Comment=http://xan-manning.co.uk/
#AutoIt3Wrapper_Res_Description=(Digital)Caffeine
#AutoIt3Wrapper_Res_Fileversion=1.5.1.3
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=P
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2010 Xan Manning
#AutoIt3Wrapper_Res_Field=Made By|Xan Manning
#AutoIt3Wrapper_Res_Field=Email|xan.manning at gmail .com
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#AutoIt3Wrapper_Res_Icon_Add=_caffeine.ico
#AutoIt3Wrapper_Run_cvsWrapper=Y
#endregion

Opt("GuiOnEventMode",1)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1); no default tray menuitems

;---------------Tray event values----------------

Global $TRAY_CHECKED					= 1
Global $TRAY_UNCHECKED					= 4
Global $TRAY_DISABLED					= 128
Global $SPI_SETSCREENSAVEACTIVE 		= 0x0011
Global $WININI							= BitOR(1, 2)

;---------------Set initial variables----------------

$enableShift = IniRead("DigitalCaffeine.ini", "config", "UseShift", False)
$enableMouse = IniRead("DigitalCaffeine.ini", "config", "UseMouse", False)

If $CmdLine[0] > 0 And $CmdLine[1] == "-useshift" And Not($enableMouse == True) Then
	$enableShift = True
ElseIf Not($enableShift == True) Then
	$enableShift = False
EndIf

If $CmdLine[0] > 0 And $CmdLine[1] == "-usemouse" And Not($enableShift == True)  Then
	$enableMouse = True
ElseIf Not($enableMouse == True) Then
	$enableMouse = False
EndIf

If $enableMouse == True Then
	$lastpos = MouseGetPos()
Else
	$lastpos = False
EndIf

$sleepTime = 1000 * 59
$runWhile = True
If IsAdmin() Then
	_WinAPI_SystemParametersInfo($SPI_SETSCREENSAVEACTIVE, 0, 0, $WININI)
EndIf
$quiet = IniRead("DigitalCaffeine.ini", "config", "Quiet", False)
    
;---------------Build UI----------------
TraySetClick(16)

$enableitem = TrayCreateItem("Enable")
TrayItemSetOnEvent(-1, "toggleScript")
TrayItemSetState($enableitem, $TRAY_CHECKED)
$quietitem = TrayCreateItem("Quiet")
TrayItemSetOnEvent(-1,"quietScript")

If $quiet == True Then
	TrayItemSetState($quietitem, $TRAY_CHECKED)
Else
	TrayItemSetState($quietitem, $TRAY_UNCHECKED)
EndIf

$mouseitem = TrayCreateItem("Use Mouse")
TrayItemSetOnEvent(-1,"useMouse")

If $enableMouse == True Then
	TrayItemSetState($mouseitem, $TRAY_CHECKED)
Else
	TrayItemSetState($mouseitem, $TRAY_UNCHECKED)
EndIf

If IsAdmin() Then
	TrayItemSetState($mouseitem, $TRAY_DISABLED)
	TrayCreateItem("")
	$adminitem = TrayCreateItem("System Parameter Control")
	TrayItemSetState($adminitem, $TRAY_DISABLED)
EndIf

TrayCreateItem("")
$infoitem = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "DisplayAbout")
TrayItemSetState($infoitem, $TRAY_UNCHECKED)
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "ExitEvent")

TraySetIcon(@AutoItExe)

TraySetState()
TraySetToolTip("(Digital)Caffeine Enabled")
If $quiet == False Then
	TraySetToolTip("(Digital)Caffeine Enabled")
	TrayTip("Enabled (Digital)Caffeine", "Caffeine has now been enabled and is running in the background.", 20, 1)
Else
	TraySetToolTip("(Digital)Caffeine Enabled [Quiet]")
EndIf

;---------------Main loop----------------

$counter = 0

While 1
    If $runWhile == True And IsAdmin() == False Then
	$counter = 0
	$sleptFor = 0
	
		If $enableShift == True Then
			Send("{SHIFTUP}")
		ElseIf $enableMouse == True Then
			$currentpos = MouseGetPos()
			If $lastpos[0] == $currentpos[0] And $lastpos[1] == $currentpos[1] Then
				MouseMove($currentpos[0], $currentpos[1] + 60, 5)
				$newpos = MouseGetPos()
				If $newpos[0] == $lastpos[0] And $newpos[1] == $lastpos[1] Then
					MouseMove($currentpos[0], $currentpos[1] - 60, 5)
				EndIf
				MouseMove($currentpos[0], $currentpos[1], 5)
			EndIf
		Else
			Send("{NUMLOCK toggle}")
			Send("{NUMLOCK toggle}")
		EndIf
	
	$runWhile = True
		
	EndIf
	
	While $counter < 10
		If $enableMouse == True Then
			$currentpos = MouseGetPos()
			If $lastpos[0] == $currentpos[0] And $lastpos[1] == $currentpos[1] Then
				$lastpos = $currentpos
			EndIf
		EndIf
		Sleep($sleepTime / 10)
		$counter = $counter + 1
	WEnd

	
	If $enableMouse == True Then
		$lastpos = $currentpos
	EndIf
	
WEnd

Exit

;---------------Functions----------------

Func DisplayAbout()
	TrayItemSetState($infoitem,$TRAY_UNCHECKED)
	MsgBox(64, "About (Digital)Caffeine.", "(Digital)Caffeine" & @CRLF & "Written by Xan Manning, 2010" & @CRLF & @CRLF & "Stops the screensaver by simulating keypress." & @CRLF & @CRLF & "http://xan-manning.co.uk/", 300)
EndFunc

Func ExitEvent()
	If IsAdmin() Then
		_WinAPI_SystemParametersInfo($SPI_SETSCREENSAVEACTIVE, 1, 0, $WININI)
	EndIf
    Exit
EndFunc

Func toggleScript()
	If $runWhile == False Then
		TrayItemSetState($enableitem,$TRAY_CHECKED)
		$runWhile = True
		TraySetIcon(@AutoItExe)
		If IsAdmin() Then
			_WinAPI_SystemParametersInfo($SPI_SETSCREENSAVEACTIVE, 0, 0, $WININI)
		EndIf
		If $quiet == False Then
			TrayTip("Enabled (Digital)Caffeine", "Caffeine has now been enabled and is running in the background.", 20, 1)
			TraySetToolTip("(Digital)Caffeine Enabled")
		Else
			TraySetToolTip("(Digital)Caffeine Enabled [Quiet]")
		EndIf		
	ElseIf $runWhile == True Then
		TrayItemSetState($enableitem,$TRAY_UNCHECKED)
		TraySetIcon(@AutoItExe, -5)
		$runWhile = False
		If IsAdmin() Then
			_WinAPI_SystemParametersInfo($SPI_SETSCREENSAVEACTIVE, 1, 0, $WININI)
		EndIf
		If $quiet == False Then
			TrayTip("Disabled (Digital)Caffeine", "Caffeine is still running but is disabled.", 20, 1)
			TraySetToolTip("(Digital)Caffeine Disabled")
		Else
			TraySetToolTip("(Digital)Caffeine Disabled [Quiet]")
		EndIf
	EndIf
	
EndFunc

Func useMouse()
	If $enableMouse == True Then
		$enableMouse = False
		IniWrite ("DigitalCaffeine.ini", "config", "UseMouse", False)
		TrayItemSetState($mouseitem,$TRAY_UNCHECKED)
		If $quiet == False Then
			TrayTip("(Digital)Caffeine", "Caffeine will now simulate a keypress every minute.", 20, 1)
		EndIf
	Else
		$lastpos = MouseGetPos()
		$enableMouse = True
		IniWrite ("DigitalCaffeine.ini", "config", "UseMouse", True)
		TrayItemSetState($mouseitem,$TRAY_CHECKED)
		If $quiet == False Then
			TrayTip("(Digital)Caffeine", "Caffeine will now move the cursor every minute.", 20, 1)
		EndIf
	EndIf
EndFunc

Func quietScript()
	If $quiet == True Then
		$quiet = False
		IniWrite ("DigitalCaffeine.ini", "config", "Quiet", False)
		TrayItemSetState($quietitem,$TRAY_UNCHECKED)
		If $runWhile == True Then
			TraySetToolTip("(Digital)Caffeine Enabled")
		Else
			TraySetToolTip("(Digital)Caffeine Disabled")
		EndIf
	Else
		$quiet = True
		IniWrite ("DigitalCaffeine.ini", "config", "Quiet", True)
		TrayItemSetState($quietitem,$TRAY_CHECKED)
		If $runWhile == True Then
			TraySetToolTip("(Digital)Caffeine Enabled [Quiet]")
		Else
			TraySetToolTip("(Digital)Caffeine Disabled [Quiet]")
		EndIf
	EndIf
EndFunc