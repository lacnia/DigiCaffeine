#RequireAdmin
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=AutoIt3Wrapper.ico
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Compile or Run your Autoit3 script with options like update the resource information..
#AutoIt3Wrapper_Res_Description=Compile or Run your Autoit3 script with options.(Used To be Called CompileAU3)
#AutoIt3Wrapper_Res_Fileversion=1.10.1.12
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2008 Jos van der Zande
#AutoIt3Wrapper_Res_Field=Made By|Jos van der Zande
#AutoIt3Wrapper_Res_Field=Email|jdeb at autoitscript dot com
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_After=copy "%in%" "..\..\WsciteUpdates\AutoIt3Wrapper"
#AutoIt3Wrapper_Run_After=copy "%out%" "..\..\WsciteUpdates\AutoIt3Wrapper"
#AutoIt3Wrapper_Run_After=copy "%in%" "c:\program files\autoit3\SciTE\AutoIt3Wrapper"
#AutoIt3Wrapper_Run_After=aaCopy2Prod.exe "%scriptfile%.EXE" "%out%" "C:\Program Files\AutoIt3\SciTE\AutoIt3Wrapper" "%in%" %fileversion% %fileversionnew%
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sf /nsdp /gd
#AutoIt3Wrapper_Run_Obfuscator=y
;~ #Obfuscator_Parameters=/striponly
#AutoIt3Wrapper_Run_cvsWrapper=v
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_cvsWrapper_Parameters=/comments "%fileversion% \n"
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#RequireAdmin
#Region AutoIT General Settings & Includes
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <Constants.au3>
; get program version for display purpose
Global $VERSION = FileGetVersion(@ScriptFullPath)
;~ $VERSION = StringLeft($VERSION, StringInStr($VERSION, ".", 0, -1) - 1)
; Only show for the main script
If Not StringInStr($CMDLINERAW, "/watcher") Then
	ConsoleWrite("+>" & @HOUR & ":" & @MIN & ":" & @SEC & " Starting AutoIt3Wrapper v." & $VERSION)
	ConsoleWrite('    Environment(Language:' & @OSLang & "  Keyboard:" & @KBLayout & "  OS:" & @OSVersion & "/" & @OSServicePack & "  CPU:" & @ProcessorArch)
	If @AutoItX64 Then ConsoleWrite('  X64')
	If Not @AutoItUnicode Then ConsoleWrite('  ANSI')
	ConsoleWrite(")" & @CRLF)
EndIf
;~ AutoItSetOption("RunErrorsFatal", 0)
;
#EndRegion AutoIT General Settings & Includes
#Region Declare variables
Global $CCFExplorerPath = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Config", "CCFExplorerPath", @ScriptDir)
Global $RCExePath = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Config", "RCExePath", "")
; Define variables
;-------------------------------------------------------------------------------------------
Global $ScriptFile_In = "", $ScriptFile_In_Ext = "", $ScriptFile_In_Obfuscated = "", $ScriptFile_Out = "", $ScriptFile_Out_Type = ""
Global $INP_Icon = "", $INP_Compression = "", $INP_AutoIT3_Version = ""
Global $AutoIT3_PGM = "", $AUT2EXE_PGM = "", $INP_AutoitDir = ""
Global $INP_Run_Debug_Mode = 0, $INP_UseUpx = "", $INP_UseAnsi = "", $INP_UseX64 = "", $INP_Comment = "", $INP_Description = "", $INP_Res_SaveSource = ""
Global $INP_Res_Language = "", $INP_RES_requestedExecutionLevel = "", $INP_Fileversion = "", $INP_Fileversion_New = "", $INP_Fileversion_AutoIncrement = "", $INP_LegalCopyright = ""
Global $INP_ProductVersion = "", $INP_CompiledScript = "", $INP_FieldName1 = "", $INP_FieldValue1 = "", $INP_FieldName2 = "", $INP_FieldValue2 = "", $INP_RES_FieldCount = 0, $INP_FieldName[16]
Global $INP_FieldValue[16], $INP_Run_Tidy = "", $INP_Run_Obfuscator = "", $INP_Tidy_Stop_OnError, $INP_Run_AU3Check = "", $INP_Add_Constants = ""
Global $INP_AU3Check_Stop_OnWarning, $INP_AU3Check_Parameters, $INP_Run_Before, $INP_Run_After, $INP_Run_cvsWrapper, $INP_cvsWrapper_Parameters
Global $INP_Plugin, $INP_Change2CUI, $INP_Icons[1], $INP_Icons_cnt = 0, $INP_Files[1], $INP_Files_cnt = 0, $TempFile, $TempFile2
Global $IconResBase = 49 ;
Global $ObfuscatorCmdLine
Global $DebugIcon = ""
Global $INP_Resource = 0
Global $INP_Resource_Version = 0
Global $Parameter_Mode = 0
Global $Debug = 0
Global $Registry = "HKCU\Software\AutoIt v3"
Global $RegistryLM = "HKLM\Software\AutoIt v3\Autoit"
Global $Option = "Compile"
Global $s_CMDLine = ""
Global $SciTE_Dir = RegRead('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\SciTE.exe', '')
Global $ToTalFile
Global $H_Outf
If StringInStr($SciTE_Dir, "\", '', -1) > 0 Then $SciTE_Dir = StringLeft($SciTE_Dir, StringInStr($SciTE_Dir, "\", '', -1) - 1)
Global $CurSciTEFile, $CurSciTELine, $FindVer, $CurSelection
Global $dummy, $V_Arg, $T_Var, $H_Cmp, $H_au3, $rc, $Save_Workdir, $AUT2EXE_DIR, $AUT2EXE_PGM_N, $msg, $AUT2EXE_PGM_VER
Global $LSCRIPTDIR, $AutoIt_Icon, $INP_Icon_Temp, $AutoIt_Icon_Dir
Global $InputFileIsUTF16 = 0
Global $ProcessBar_Title
Global $Pid, $Handle, $Return_Text, $ExitCode
Global $sCmd
$dummy = RegRead($Registry & "\Aut2Exe", "LastScriptDir")
If @error Then
	$Registry = "HKCU\Software\Hiddensoft\AutoIT3"
EndIf
$dummy = RegRead($RegistryLM, 'InstallDir')
If @error Then
	$RegistryLM = "HKLM\Software\Hiddensoft\AutoIT3"
EndIf
Global $CurrentAutoIt_InstallDir = RegRead($RegistryLM, 'InstallDir')
#EndRegion Declare variables
#Region Commandline lexing
; retrieve commandline parameters
;-------------------------------------------------------------------------------------------
$V_Arg = "Valid Arguments are:" & @CRLF
$V_Arg = $V_Arg & "    /in  ScriptFile " & @CRLF
$V_Arg = $V_Arg & "    /out Targetfile " & @CRLF
$V_Arg = $V_Arg & "    /icon IconFile " & @CRLF
;~ $V_Arg = $V_Arg & "    /pass passphrase " & @CRLF
$V_Arg = $V_Arg & "    /comp 0 to 4  (Lowest to Highest) " & @CRLF
$V_Arg = $V_Arg & "    /nopack  Skip UPX step." & @CRLF
$V_Arg = $V_Arg & "    /pack    Run UPX (Default) " & @CRLF
$V_Arg = $V_Arg & "    /ansi    Compile as Ansi for use with Win9x. " & @CRLF
$V_Arg = $V_Arg & "    /unicode Default compile with Unocode support. " & @CRLF
$V_Arg = $V_Arg & "    /x64     Compile for x64 OS." & @CRLF
$V_Arg = $V_Arg & "    /console Change output program to CUI" & @CRLF
$V_Arg = $V_Arg & "    /Gui     Default, output program will be GUI" & @CRLF
;
For $x = 1 To $CMDLINE[0]
	$T_Var = StringLower($CMDLINE[$x])
	;MsgBox( 1, "debug", "argument: " & $t_var,1)
	$Parameter_Mode = 1
	Select
		Case $T_Var = "/Watcher"
			; when AutoIt3Wrapper is lanched as watcher to see if the original AutoIt3Wrapper is canceled.
			$H_Cmp = $CMDLINE[$x + 1]
			$H_au3 = $CMDLINE[$x + 2]
			While ProcessExists($H_Cmp) And ProcessExists($H_au3)
				Sleep(500)
			WEnd
			Sleep(500)
			If ProcessExists($H_au3) Then
				ProcessClose($H_au3)
				_RefreshSystemTray()
			EndIf
			Exit
		Case $T_Var = "/?" Or $T_Var = "/help"
			MsgBox(1, "Compile Aut2EXE", "Compile an AutoIt3 Script." & @LF & "commandline argument: " & $T_Var & @LF & $V_Arg)
			Exit
		Case $T_Var = "/in"
			$x = $x + 1
			$ScriptFile_In = $CMDLINE[$x]
		Case $T_Var = "/out"
			$x = $x + 1
			$ScriptFile_Out = $CMDLINE[$x]
		Case $T_Var = "/icon"
			$x = $x + 1
			$INP_Icon = $CMDLINE[$x]
			$DebugIcon = $DebugIcon & "/icon: " & $INP_Icon & @CRLF
		Case $T_Var = "/pass"
			$x = $x + 1
;~ 			$INP_PassPhrase = $CMDLINE[$x]
;~ 			$INP_PassPhrase2 = $CMDLINE[$x]
;~ 			$INP_Allow_Decompile = "y"
		Case $T_Var = "/compress" Or $T_Var = "/comp" Or $T_Var = "/compression"
			$x = $x + 1
			$INP_Compression = Number($CMDLINE[$x])
		Case $T_Var = "/nodecompile"
;~ 			$INP_Allow_Decompile = "n"


		Case $T_Var = "/Pack"
			$INP_UseUpx = "y"
		Case $T_Var = "/NoPack"
			$INP_UseUpx = "n"
			
		Case $T_Var = "/Compression"
			$INP_Compression = "y"


		Case $T_Var = "/GUI"
;~ 			Just for compatibility sake
		Case $T_Var = "/Console"
			$INP_Change2CUI = "y"
		Case $T_Var = "/Unicode"
			$INP_UseAnsi = "n"
			$INP_UseX64 = "n"
		Case $T_Var = "/ansi"
			$INP_UseAnsi = "y"
			$INP_UseX64 = "n"
		Case $T_Var = "/x64"
			$INP_UseX64 = "y"
			$INP_UseAnsi = "n"
		Case $T_Var = "/run"
			$Option = "Run"
		Case $T_Var = "/debug"
			$Debug = 1
		Case $T_Var = "/au3check"
			$Option = "AU3Check"
		Case $T_Var = "/compiledefaults"
			; $Option2 = "defaults"  ; Obsolete
		Case $T_Var = "/beta"
			$INP_AutoIT3_Version = "Beta"
		Case $T_Var = "/prod"
			$INP_AutoIT3_Version = "Prod"
		Case $T_Var = "/Autoit3Dir"
			$x = $x + 1
			$INP_AutoitDir = $CMDLINE[$x]
		Case $T_Var = "/UserParams"
			$s_CMDLine = StringTrimLeft($CMDLINERAW, StringInStr($CMDLINERAW, "/UserParams") + 11)
			ExitLoop
		Case Else
			; when /run then optional parameters are allowed
			If $Option = "Compile" Then
				MsgBox(1, "Compile Aut2EXE", "Wrong commandline argument: " & $T_Var & @LF & $V_Arg)
				Exit
			EndIf
			; Build the other params used for running autoit
			$s_CMDLine = $s_CMDLine & " " & $T_Var
	EndSelect
Next
#EndRegion Commandline lexing
#Region SciTE Director Init
; Try to update the file directly in SciTE in stead of externally by means of the Director interface.
Opt("WinSearchChildren", 1)
;Global $WM_COPYDATA = 74
Global $SciTECmd
Global $SciTE_hwnd = WinGetHandle("DirectorExtension")
; Get My GUI Handle numeric
Global $My_Hwnd = GUICreate("SciTE interface", 300, 600, Default, Default, Default, $WS_EX_TOPMOST)
Global $My_Dec_Hwnd = Dec(StringTrimLeft($My_Hwnd, 2))
;Register COPYDATA message.
GUIRegisterMsg($WM_COPYDATA, "MY_WM_COPYDATA")
; Get SciTE prograqm directory
If Not FileExists($SciTE_Dir & "\SciTE.exe") Then
	$SciTE_Dir = StringReplace(SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:SciteDefaultHome"), "\\", "\")
EndIf
#EndRegion SciTE Director Init
#Region Check For SciTE4AutoIt3 updates
If SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:check.updates.scite4autoit3") = 1 Then
	If IniRead($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'LastCheckDate', '') <> _NowDate() Then
		CheckForUpdates()
		IniWrite($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'LastCheckDate', _NowDate())
	EndIf
EndIf
#EndRegion Check For SciTE4AutoIt3 updates
#Region Input retrieval/validation
; check/request for input Script File
;-------------------------------------------------------------------------------------------
While Not FileExists($ScriptFile_In) ; Or StringRight($ScriptFile_In, 4) <> '.au3'
	$ScriptFile_In = FileOpenDialog("Select script to Compile with AUT2EXE ?", RegRead($Registry & "\Aut2Exe", "LastScriptDir"), "autoit3(*.au3)", 1)
	If @error = 1 Then
		$rc = MsgBox(4100, "Autoit3 Compile", "do you want to stop the process?")
		If $rc = 6 Then Exit
	EndIf
WEnd
; Get the default values for this particular script from the ini when not specified on the commandline
;-----------------------------------------------------------------------------------------------------
If $ScriptFile_Out = "" Then
	$ScriptFile_Out = IniRead($ScriptFile_In & ".ini", "Autoit", "outfile", "")
	$ScriptFile_Out_Type = IniRead($ScriptFile_In & ".ini", "Autoit", "outfile_type", "")
Else
	$ScriptFile_Out_Type = StringRight($ScriptFile_Out, 3)
EndIf
If $INP_Icon = "" Then
	$INP_Icon = IniRead($ScriptFile_In & ".ini", "Autoit", "icon", "")
	$DebugIcon = $DebugIcon & "INI icon: " & $INP_Icon & @CRLF
EndIf
; Retrieve Script defaults from its previous saved INI file
If FileExists($ScriptFile_In & ".ini") Then
	If MsgBox(262144 + 4096 + 4, "AutoIt3Wrappper", "Found INI file containing OLD AutoIt3Wrapper information." & @LF & _
			"Do you want to updated your script with the appropriate #Directives and Recycle the INI ?", 10) = 6 Then
		Convert_RES_INI_to_Directives()
	EndIf
	If $INP_Compression = "" Then $INP_Compression = IniRead($ScriptFile_In & ".ini", "Autoit", "Compression", "")
;~ 	If $INP_PassPhrase = "" Then $INP_PassPhrase = IniRead($ScriptFile_In & ".ini", "Autoit", "PassPhrase", "")
;~ 	If $INP_PassPhrase2 = "" Then $INP_PassPhrase2 = IniRead($ScriptFile_In & ".ini", "Autoit", "PassPhrase", "")
;~ 	If $INP_Allow_Decompile = "" Then $INP_Allow_Decompile = IniRead($ScriptFile_In & ".ini", "Autoit", "Allow_Decompile", "")
	If $INP_UseUpx = "" Then $INP_UseUpx = IniRead($ScriptFile_In & ".ini", "Autoit", "UseUpx", "")
	If $INP_UseAnsi = "" Then $INP_UseAnsi = IniRead($ScriptFile_In & ".ini", "Autoit", "UseAnsi", "")
	If $INP_UseX64 = "" Then $INP_UseX64 = IniRead($ScriptFile_In & ".ini", "Autoit", "Usex64", "")
	$INP_Comment = IniRead($ScriptFile_In & ".ini", "Res", "Comment", "")
	$INP_Description = IniRead($ScriptFile_In & ".ini", "Res", "Description", "")
	$INP_Fileversion = IniRead($ScriptFile_In & ".ini", "Res", "Fileversion", "")
	$INP_Fileversion_AutoIncrement = IniRead($ScriptFile_In & ".ini", "Res", "Fileversion_AutoIncrement", "")
	$INP_LegalCopyright = IniRead($ScriptFile_In & ".ini", "Res", "LegalCopyright", "")
	$INP_Res_SaveSource = IniRead($ScriptFile_In & ".ini", "Res", "SaveSource", "")
	$INP_FieldName1 = IniRead($ScriptFile_In & ".ini", "Res", "Field1Name", "")
	$INP_FieldValue1 = IniRead($ScriptFile_In & ".ini", "Res", "Field1Value", "")
	$INP_FieldName2 = IniRead($ScriptFile_In & ".ini", "Res", "Field2Name", "")
	$INP_FieldValue2 = IniRead($ScriptFile_In & ".ini", "Res", "Field2Value", "")
	$INP_Run_AU3Check = IniRead($ScriptFile_In & ".ini", "Other", "Run_AU3Check", "")
	$INP_AU3Check_Stop_OnWarning = IniRead($ScriptFile_In & ".ini", "Other", "AU3Check_Stop_OnWarning", "")
	$INP_AU3Check_Parameters = IniRead($ScriptFile_In & ".ini", "Other", "AU3Check_Parameter", "")
	$INP_Run_Before = IniRead($ScriptFile_In & ".ini", "Other", "Run_Before", "")
	$INP_Run_After = IniRead($ScriptFile_In & ".ini", "Other", "Run_After", "")
	$INP_Run_cvsWrapper = IniRead($ScriptFile_In & ".ini", "Other", "Run_cvsWrapper", "")
	$INP_cvsWrapper_Parameters = IniRead($ScriptFile_In & ".ini", "Other", "cvsWrapper_Parameter", "")
	$INP_Change2CUI = IniRead($ScriptFile_In & ".ini", "Other", "Change2CUI", "")
EndIf
;Retrieve AutoIt3Wrapper Defaults from AutoIt3Wrapper.INI
If $ScriptFile_Out_Type = "" Then $ScriptFile_Out_Type = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "outfile_type", "")
If $INP_Icon = "" Then $INP_Icon = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "icon", "")
If $INP_Compression = "" Then $INP_Compression = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "Compression", "")
;~ If $INP_PassPhrase = "" Then $INP_PassPhrase = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "PassPhrase", "")
;~ If $INP_PassPhrase2 = "" Then $INP_PassPhrase2 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "PassPhrase", "")
;~ If $INP_Allow_Decompile = "" Then $INP_Allow_Decompile = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "Allow_Decompile", "")
If $INP_UseUpx = "" Then $INP_UseUpx = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "UseUpx", "")
If $INP_UseAnsi = "" Then $INP_UseAnsi = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "UseAnsi", "")
If $INP_UseX64 = "" Then $INP_UseX64 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "UseX64", "")
;If $INP_AutoitDir = "" Then $AUT2EXE_PGM = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Autoit", "aut2exe", "")
If $INP_Res_Language = "" Then $INP_Res_Language = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Language", "")
If $INP_RES_requestedExecutionLevel = "" Then $INP_RES_requestedExecutionLevel = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "RequestedExecutionLevel", "")
If $INP_Comment = "" Then $INP_Comment = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Comment", "")
If $INP_Description = "" Then $INP_Description = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Description", "AutoIt v3 Compiled Script")
If $INP_Fileversion = "" Then $INP_Fileversion = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Fileversion", "")
If $INP_Fileversion_AutoIncrement = "" Then $INP_Fileversion_AutoIncrement = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Fileversion_AutoIncrement", "")
If $INP_LegalCopyright = "" Then $INP_LegalCopyright = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "LegalCopyright", "")
If $INP_Res_SaveSource = "" Then $INP_Res_SaveSource = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "SaveSource", "")
If $INP_FieldName1 = "" Then $INP_FieldName1 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field1Name", "")
If $INP_FieldValue1 = "" Then $INP_FieldValue1 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field1Value", "")
If $INP_FieldName2 = "" Then $INP_FieldName2 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field2Name", "")
If $INP_FieldValue2 = "" Then $INP_FieldValue2 = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Res", "Field2Value", "")
If $INP_Run_Tidy = "" Then $INP_Run_Tidy = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_Tidy", "")
If $INP_Run_AU3Check = "" Then $INP_Run_AU3Check = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_AU3Check", "")
If $INP_AU3Check_Stop_OnWarning = "" Then $INP_AU3Check_Stop_OnWarning = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "AU3Check_Stop_OnWarning", "")
If $INP_AU3Check_Parameters = "" Then $INP_AU3Check_Parameters = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "AU3Check_Parameter", "")
If $INP_Run_Before = "" Then $INP_Run_Before = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_Before", "")
If $INP_Run_After = "" Then $INP_Run_After = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_After", "")
If $INP_Run_cvsWrapper = "" Then $INP_Run_cvsWrapper = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Run_cvsWrapper", "")
If $INP_cvsWrapper_Parameters = "" Then $INP_cvsWrapper_Parameters = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "cvsWrapper_Parameter", "")
If $INP_Change2CUI = "" Then $INP_Change2CUI = IniRead(@ScriptDir & "\AutoIt3Wrapper.ini", "Other", "Change2CUI", "")
; Set Fields use to determine the extension
_PathSplit($ScriptFile_In, $dummy, $dummy, $dummy, $ScriptFile_In_Ext)
; Get Predefined settings from the Scriptfile itself. These will override all other settings
;-------------------------------------------------------------------------------------------
Retrieve_PreProcessor_Info()
; set proper defaults
; set proper defaults and translate/validate values
SetDefaults($INP_AutoIT3_Version, "Prod", "P=Prod;B=Beta", "Prod;Beta", 0)
SetDefaults($ScriptFile_Out_Type, "exe", "", "exe;a3x", 0)
If Not FileExists($INP_AutoitDir & "\Autoit3.exe") Then $INP_AutoitDir = ""
;
If $INP_AutoIT3_Version = "beta" Then
	If $INP_AutoitDir = "" Then $INP_AutoitDir = RegRead($RegistryLM, 'BetaInstallDir')
	$ObfuscatorCmdLine &= "/Beta"
Else
	If $INP_AutoitDir = "" Then $INP_AutoitDir = RegRead($RegistryLM, 'InstallDir')
EndIf
;
If Not FileExists($INP_AutoitDir & "\Autoit3.exe") Or $INP_AutoitDir = "" Then
	$INP_AutoitDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\Scite") - 1)
	Select
		Case $INP_AutoIT3_Version = "beta" And FileExists(@ProgramFilesDir & "\AutoIt3\beta\Au3Check.exe")
			$INP_AutoitDir = @ProgramFilesDir & "\AutoIt3\Beta"
		Case $INP_AutoIT3_Version = "beta" And FileExists($INP_AutoitDir & "\Beta\au3check.exe")
			; Use first part of the ScriptDir path.
		Case FileExists(@ProgramFilesDir & "\AutoIt3\Au3Check.exe")
			$INP_AutoitDir = @ProgramFilesDir & "\AutoIt3"
		Case FileExists($INP_AutoitDir & "\au3check.exe")
			; Use first part of the ScriptDir path.
		Case Else
			ConsoleWrite("! Unable to determine the location of the AutoIt3 program directory!" & @CRLF)
	EndSelect
EndIf
;
SetDefaults($INP_Compression, 2, "", "0;1;2;3;4", 1)
;~ SetDefaults($INP_Allow_Decompile, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0)
SetDefaults($INP_UseUpx, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_UseAnsi, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_UseX64, "n", "auto=a;yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Fileversion_AutoIncrement, "n", "prompt=p;yes=y;no=n;1=y;0=n;4=n", "y;n;p", 0, 0)
SetDefaults($INP_Run_AU3Check, "y", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_Tidy, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_Obfuscator, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Run_cvsWrapper, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n;v", 0, 0)
SetDefaults($INP_AU3Check_Stop_OnWarning, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Res_SaveSource, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
SetDefaults($INP_Change2CUI, "n", "yes=y;no=n;1=y;0=n;4=n", "y;n", 0, 0)
;
If $ScriptFile_Out = StringRight($ScriptFile_In, StringLen($ScriptFile_In)) Then
	ConsoleWrite("- Cannot specify the same output filename as the inputfile: " & $ScriptFile_Out & " ==> Changing to default (scriptname.exe)." & @CRLF)
	$ScriptFile_Out = ""
EndIf
If $ScriptFile_Out = "" Then
	If $ScriptFile_Out_Type <> "" Then
		$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.' & $ScriptFile_Out_Type
	Else
		$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
	EndIf
EndIf
$ScriptFile_Out = _PathFull($ScriptFile_Out)
; fix _PAthFull() problem
If StringLeft($ScriptFile_Out, 3) = "\\\" Then $ScriptFile_Out = StringMid($ScriptFile_Out, 2)
;If $INP_Icon <> "" Then $INP_Icon = _PathFull($INP_Icon)
; save current workdir for later use
$Save_Workdir = @WorkingDir
; retrieve aut3exe directory
;-------------------------------------------------------------------------------------------
If $Option = "Compile" Then
	If $AUT2EXE_PGM <> "" And FileExists($AUT2EXE_PGM) Then
		; support old override for AUT2EXE
	ElseIf $INP_AutoitDir <> "" And FileExists($INP_AutoitDir & "\aut2exe\aut2exe.exe") Then
		If (@OSTYPE = "WIN32_WINDOWS") And FileExists($INP_AutoitDir & "\aut2exe\aut2exea.exe") Then
			$AUT2EXE_PGM = $INP_AutoitDir & "\aut2exe\aut2exea.exe"
		ElseIf @ProcessorArch <> "x86" And FileExists($INP_AutoitDir & "\aut2exe\aut2exe_x64.exe") And StringInStr(RegRead("HKCR\AutoIt3Scrip\Shell\Compile\Command", ""), "aut2exe_x64.exe") Then
			$AUT2EXE_PGM = $INP_AutoitDir & "\aut2exe\aut2exe_x64.exe"
		Else
			$AUT2EXE_PGM = $INP_AutoitDir & "\aut2exe\aut2exe.exe"
		EndIf
	Else
		If @OSTYPE = "WIN32_WINDOWS" Or $INP_UseAnsi = "y" Then
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & '\aut2exe\Aut2Exea.exe'
			If $AUT2EXE_PGM = "" Or Not FileExists($AUT2EXE_PGM) Then
				$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & '\aut2exe\Aut2Exe.exe'
			EndIf
		ElseIf @ProcessorArch <> "x86" And FileExists($CurrentAutoIt_InstallDir & "\aut2exe\aut2exe_x64.exe") And StringInStr(RegRead("HKCR\AutoIt3Scrip\Shell\Compile\Command", ""), "aut2exe_x64.exe") Then
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & "\aut2exe\aut2exe_x64.exe"
		Else
			$AUT2EXE_PGM = $CurrentAutoIt_InstallDir & '\aut2exe\Aut2Exe.exe'
		EndIf
	EndIf
	$AUT2EXE_DIR = StringLeft($AUT2EXE_PGM, StringInStr($AUT2EXE_PGM, "\", 0, -1))
	; check if aut2exe.exe files are all there
	;-------------------------------------------------------------------------------------------
	$AUT2EXE_PGM_N = ""
	; ensure the drive letter in part of the path to aut2exe
	; this is needed when aut2exe is specified as: "#AutoIt3Wrapper_AUT2EXE=\winutil\AutoIt3\Au3beta\aut2exe.exe"
	If FileExists($AUT2EXE_PGM) Then
		FileChangeDir($AUT2EXE_DIR)
		$AUT2EXE_DIR = @WorkingDir
		FileChangeDir($Save_Workdir)
	Else
		; Prompt for the location of AUT2EXE
		While (Not FileExists($AUT2EXE_PGM)) Or (Not FileExists($AUT2EXE_DIR & "\AutoItSC.bin")) Or (Not FileExists($AUT2EXE_DIR & "\upx.exe"))
			If $AUT2EXE_PGM_N <> "" Then
				$msg = ""
				If Not FileExists($AUT2EXE_PGM) Then $msg = $AUT2EXE_PGM & " doesn exist." & @LF
				If Not FileExists($AUT2EXE_DIR & "\AutoItSC.bin") Then $msg = $AUT2EXE_DIR & "\AutoItSC.bin" & " doesn't exist." & @LF
				If Not FileExists($AUT2EXE_DIR & "\upx.exe") Then $msg = $AUT2EXE_DIR & "\upx.exe" & " doesn't exist." & @LF
				MsgBox(4096, "Error.", $msg)
			EndIf
			$AUT2EXE_PGM_N = FileOpenDialog("Select the correct directory with AUT2EXE,AutoItSC.bin and upx.exe ", $AUT2EXE_PGM, "aut2exe(*.*)", 1)
			If @error = 1 Then
				$rc = MsgBox(4100, "Autoit3 Compile", "do you want to stop the process?")
				If $rc = 6 Then Exit
			EndIf
			$AUT2EXE_DIR = StringLeft($AUT2EXE_PGM_N, StringInStr($AUT2EXE_PGM_N, "\", 0, -1) - 1)
			If @OSTYPE = "WIN32_WINDOWS" Then
				$AUT2EXE_PGM = $AUT2EXE_DIR & "\Aut2Exea.exe"
			Else
				$AUT2EXE_PGM = $AUT2EXE_DIR & "\Aut2Exe.exe"
			EndIf
			;If FileExists($AUT2EXE_PGM) Then
			;	RegWrite('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\Aut2Exe.exe', '', "REG_SZ", $AUT2EXE_PGM)
			;EndIf
		WEnd
	EndIf
	;get aut2exe fileversion
	;-------------------------------------------------------------------------------------------
	$AUT2EXE_PGM_VER = FileGetVersion($AUT2EXE_DIR & "\AutoitSC.bin")
	$LSCRIPTDIR = StringLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	; when just a file name is supplied it assumed it's in the scriptdirectory or Autoit ICO dir
	$AutoIt_Icon = RegRead("HKCR\AutoIt3Script\DefaultIcon", "")
	; When an ICON is specified in an INI/Commandline/Compiler directive it will check it here
	If $INP_Icon <> "" Then
		If Not StringInStr($INP_Icon, "\") Then
			$INP_Icon_Temp = $LSCRIPTDIR & $INP_Icon
			; check the scriptdir for the ICO file
			If Not FileExists($INP_Icon_Temp) Or StringInStr(FileGetAttrib($INP_Icon_Temp), "D") Then
				$AutoIt_Icon_Dir = StringLeft($AutoIt_Icon, StringInStr($AutoIt_Icon, "\", 0, -1))
				$INP_Icon_Temp = $AutoIt_Icon_Dir & $INP_Icon
				; check the Autoit ICON dir for the ICO file
				If FileExists($INP_Icon_Temp) And StringInStr(FileGetAttrib($INP_Icon_Temp), "D") = 0 Then
					$INP_Icon = $INP_Icon_Temp
				Else
					If Not (StringRight($ScriptFile_Out, 4) = ".a3x") Then ConsoleWrite("- Icon not found:  " & $INP_Icon & " ==> Changing to default ICON." & @CRLF)
					$INP_Icon = ""
				EndIf
			Else
				$INP_Icon = $INP_Icon_Temp
			EndIf
		Else
			If Not FileExists($INP_Icon) Then
				ConsoleWrite("- Icon not found: " & $INP_Icon & " ==> Changing to default ICON." & @CRLF)
				$INP_Icon = ""
			EndIf
			If StringInStr(FileGetAttrib($INP_Icon), "D") Then
				ConsoleWrite("- Icon is a Directory: " & $INP_Icon & " ==> Changing to default ICON." & @CRLF)
				$INP_Icon = ""
			EndIf
		EndIf
	EndIf
	; when icon is not specified then check if the lasticon used is valid
	If $INP_Icon = "" Then
		$INP_Icon = RegRead($Registry & "\Aut2exe", "LastIcon")
		; When LastIcon doesnt exists then use Default Icon
		If $INP_Icon <> "" And Not FileExists($INP_Icon) Then
			ConsoleWrite("- LastUsed Icon not found: " & $INP_Icon & " ==> Changing to default ICON:" & $AutoIt_Icon & @CRLF)
			$INP_Icon = $AutoIt_Icon
		EndIf
	EndIf
	;
	; determine if the release is higher than 101..  if so then add this to the possible parameter list
	If $AUT2EXE_PGM_VER > '3.0.101.0' Then
		$V_Arg = $V_Arg & "    /nodecompile " & @CRLF
	EndIf
	;-------------------------------------------------------------------------------------------
	; prepare all variables for the commandline programs and AUT2EXE
	;-------------------------------------------------------------------------------------------
	If $INP_Run_Obfuscator = "y" Then
		$s_CMDLine = ' /in "' & StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '_Obfuscated' & $ScriptFile_In_Ext & '"'
		If $ScriptFile_Out = "" Then $ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
	Else
		$s_CMDLine = ' /in "' & $ScriptFile_In & '"'
	EndIf
	If $ScriptFile_Out <> "" Then
		; Check it the target directory is valid
		$ScriptFile_Out = StringReplace($ScriptFile_Out, "/", "\")
		If StringInStr($ScriptFile_Out, "\", 0, -1) And Not FileExists(StringLeft($ScriptFile_Out, StringInStr($ScriptFile_Out, "\", 0, -1) - 1)) Then
			;$s_CMDLine = $s_CMDLine & ' /out "' & $ScriptFile_Out & '"'
			ConsoleWrite("- Output path: " & StringLeft($ScriptFile_Out, StringInStr($ScriptFile_Out, "\", 0, -1) - 1) & " not found, changing it to:")
			$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.exe'
			ConsoleWrite($ScriptFile_Out & @CRLF)
		Else
			$s_CMDLine = $s_CMDLine & ' /out "' & $ScriptFile_Out & '"'
		EndIf
	EndIf
	; version is =< 3.0.101
;~ 	If $AUT2EXE_PGM_VER > '3.0.101.0' Then
;~ 		; only supported after 3.0.101
;~ 		If $INP_Allow_Decompile = "y" Then
;~ 			If $INP_PassPhrase <> "" Then $s_CMDLine = $s_CMDLine & ' /pass "' & $INP_PassPhrase & '"'
;~ 		Else
;~ 			$s_CMDLine = $s_CMDLine & ' /nodecompile'
;~ 		EndIf
;~ 	Else
;~ 		If $INP_PassPhrase <> "" Then $s_CMDLine = $s_CMDLine & ' /pass "' & $INP_PassPhrase & '"'
;~ 	EndIf
	If $INP_Icon <> "" Then $s_CMDLine = $s_CMDLine & ' /icon "' & $INP_Icon & '"'
	If $INP_Compression > -1 And $INP_Compression < 5 Then $s_CMDLine = $s_CMDLine & ' /comp ' & $INP_Compression & ''
	; When the info doesn't come from preprocessor statements then,
	; Show progress bar
	$ProcessBar_Title = "(" & $VERSION & ") Processing : " & StringTrimLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	ProgressOn($ProcessBar_Title, "Compile", "Starting", 50, 10, 18)
	; run process defined to be run before the compile process
	$INP_Run_Before = StringSplit($INP_Run_Before, "|")
	For $x = 1 To $INP_Run_Before[0]
		If StringStripWS($INP_Run_Before[$x], 3) <> "" Then
			ProgressSet(95, "Running :" & $INP_Run_Before[$x])
			; translate possible %..% to the actual values
			$INP_Run_Before[$x] = Convert_Variables($INP_Run_Before[$x])
			ConsoleWrite("> Running:" & $INP_Run_Before[$x] & @CRLF)
			$rc = Run(@ComSpec & ' /C ' & $INP_Run_Before[$x] & '', '', @SW_HIDE, 2)
			ShowStdOutErr($rc)
			;$RC = RunWait($INP_Run_Before)
		EndIf
	Next
	;
	WinActivate($ProcessBar_Title)
ElseIf $Option = "AU3Check" Then
	$INP_Run_AU3Check = "y"
Else ; $Option = "Run"
	$ProcessBar_Title = "(" & $VERSION & ") Processing : " & StringTrimLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	; set AutoIt3.Exe to the Autoit3dir specified on the commandline when supplied
	If $INP_AutoitDir <> "" And FileExists($INP_AutoitDir & "\autoit3.exe") Then
		If (@OSTYPE = "WIN32_WINDOWS" Or $INP_UseAnsi = "y") And FileExists($INP_AutoitDir & "\autoit3a.exe") Then
			$AutoIT3_PGM = $INP_AutoitDir & "\autoit3a.exe"
		ElseIf @ProcessorArch <> "x86" And FileExists($INP_AutoitDir & "\autoit3_x64.exe") And StringInStr(RegRead("HKCR\AutoIt3Scrip\Shell\Run\Command", ""), "AutoIt3_x64.exe") Then
			$AutoIT3_PGM = $INP_AutoitDir & "\autoit3_x64.exe"
		Else
			$AutoIT3_PGM = $INP_AutoitDir & "\autoit3.exe"
		EndIf
	Else
		If @OSTYPE = "WIN32_WINDOWS" Or $INP_UseAnsi = "y" Then
			$AutoIT3_PGM = RegRead($RegistryLM, 'InstallDir') & '\autoit3a.exe'
			If $AutoIT3_PGM = "" Or Not FileExists($AutoIT3_PGM) Then
				$AutoIT3_PGM = RegRead($RegistryLM, 'InstallDir') & '\autoit3.exe'
			EndIf
		ElseIf @ProcessorArch <> "x86" And FileExists($CurrentAutoIt_InstallDir & "\autoit3_x64.exe") And StringInStr(RegRead("HKCR\AutoIt3Scrip\Shell\Run\Command", ""), "AutoIt3_x64.exe") Then
			$AutoIT3_PGM = $CurrentAutoIt_InstallDir & "\autoit3_x64.exe"
		Else
			$AutoIT3_PGM = RegRead($RegistryLM, 'InstallDir') & '\autoit3.exe'
		EndIf
	EndIf
	; Check if AutoIt3 really exists
	If Not FileExists($AutoIT3_PGM) Then
		ConsoleWrite('!>Error: program "' & $AutoIT3_PGM & '" is missing. Check your installation.' & @CRLF)
		Exit 999
	EndIf
EndIf
#EndRegion Input retrieval/validation
#Region Fix Includes
If $INP_Add_Constants = "y" Then Add_Constants()
#EndRegion Fix Includes
#Region Run Tidy
; Run Tidy when requested.
If Not $InputFileIsUTF16 And Not ($Option = "AU3Check") And $INP_Run_Tidy = "y" Then
	Global $TidypgmVer = ""
	Global $Tidypgm = $SciTE_Dir & "\tidy\Tidy.exe"
	Global $Tidypgmdir
	If FileExists($Tidypgm) Then
		$Tidypgmdir = $SciTE_Dir & "\tidy"
		$TidypgmVer = FileGetVersion($Tidypgm)
		If $TidypgmVer = "0.0.0.0" Then
			$TidypgmVer = ""
		Else
			$TidypgmVer = "(" & $TidypgmVer & ")"
		EndIf
		ProgressSet(7, "Running Tidy ...")
		ConsoleWrite(">Running Tidy " & $TidypgmVer & "  from:" & $Tidypgmdir & @CRLF)
		;---- uses the Beta STDOUT fuunctionality ------------------------------------------
		;$Pid = Run(@ComSpec & ' /c ""' & $Tidypgm & '" "' & $ScriptFile_In & '""', '', @SW_HIDE, 2)
		$Pid = Run('"' & $Tidypgm & '" "' & $ScriptFile_In & '" /q', '', @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		$Handle = _ProcessExitCode($Pid)
		$Return_Text = ShowStdOutErr($Pid)
		$ExitCode = _ProcessExitCode($Pid, $Handle)
		_ProcessCloseHandle($Handle)
		StdioClose($Pid)
		; Show the Errors in a MSGBox
		If $ExitCode > 0 Then
			;ConsoleWrite(">Tidy Ended with Error(s). rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("Tidy ended.", $ExitCode)
			If $Option <> "Tidy" And ProcessExists("SciTe.exe") Then
				If $INP_Tidy_Stop_OnError <> "y" And StringInStr($Return_Text, " - 0 error(s)") > 0 Then
				Else
					Show_Warnings("Tidy errors", StringReplace($Return_Text, @CR, ""))
				EndIf
			EndIf
		Else
			;ConsoleWrite(">Tidy Ended. No Error(s).   rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("Tidy ended.", $ExitCode)
		EndIf
	Else
		ConsoleWrite("! *** Tidy Error: *** Skipping Tidy: " & $Tidypgm & " Not Found !" & @CRLF & @CRLF)
	EndIf
EndIf
#EndRegion Run Tidy
#Region Run AU3Check
; Run AU3Check when requested.
;If Not $InputFileIsUTF16 And ($INP_Run_AU3Check = "y" Or $INP_Run_AU3Check = 1) Then
If Not $InputFileIsUTF16 And $INP_Run_AU3Check = "y" Then
	; New INclude logic with au3check in the AutoIT directory
	Global $Au3checkpgmVer = ""
	Global $Au3checkpgmdir
	Global $Au3checkpgm = $INP_AutoitDir & "\au3check.exe"
	If FileExists($Au3checkpgm) Then
		$Au3checkpgmdir = $INP_AutoitDir
		$Au3checkpgmVer = FileGetVersion($Au3checkpgm)
		If $Au3checkpgmVer = "0.0.0.0" Then
			$Au3checkpgmVer = ""
		Else
			$Au3checkpgmVer = "(" & $Au3checkpgmVer & ")"
		EndIf
		;		ProgressSet(5, "Running AU3Check ...")
		$TempFile = @TempDir & '\au3check.log'
		FileDelete($TempFile)
		; If PlugIn functions are specified then add that to the temp au3Check.dat
		If $INP_Plugin <> "" Then
			If FileCopy($Au3checkpgmdir & "\au3check.dat", @TempDir & "\au3check.dat", 1) Then
				$INP_Plugin = StringSplit($INP_Plugin, ",")
				For $x = 1 To $INP_Plugin[0]
					FileWriteLine($Au3checkpgmdir & "\au3check.dat", "!" & StringStripWS($INP_Plugin[$x], 3) & " 0 99")
				Next
			Else
				ConsoleWrite("+> Unable to add PlugIn functions to the Au3Check tables" & @LF)
				$INP_Plugin = ""
			EndIf
		EndIf
		If $INP_AU3Check_Parameters <> "" Then
			ConsoleWrite(">Running AU3Check " & $Au3checkpgmVer & "  params:" & $INP_AU3Check_Parameters & "  from:" & $Au3checkpgmdir & @CRLF)
		Else
			ConsoleWrite(">Running AU3Check " & $Au3checkpgmVer & "  from:" & $Au3checkpgmdir & @CRLF)
		EndIf
		;
		$Pid = Run('"' & $Au3checkpgm & '" ' & $INP_AU3Check_Parameters & ' -q "' & $ScriptFile_In & '"', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		$Handle = _ProcessExitCode($Pid)
		$Return_Text = ShowStdOutErr($Pid)
		$ExitCode = _ProcessExitCode($Pid, $Handle)
		_ProcessCloseHandle($Handle)
		StdioClose($Pid)
		If $INP_Plugin <> "" Then
			FileMove(@TempDir & "\au3check.dat", $Au3checkpgmdir & "\au3check.dat", 1)
		EndIf
		; Show the Errors in a MSGBox
		If $Return_Text <> "" Then
			;ConsoleWrite(">AU3Check Ended with Error(s). rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("AU3Check ended.", $ExitCode)
			If $Option <> "AU3Check" And ProcessExists("SciTe.exe") Then
				If $INP_AU3Check_Stop_OnWarning <> "y" And StringInStr($Return_Text, " - 0 error(s)") > 0 Then
				Else
					Show_Warnings("Au3Check errors", StringReplace($Return_Text, @CR, ""))
				EndIf
			EndIf
		Else
			;ConsoleWrite(">AU3Check Ended. No Error(s).   rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("AU3Check ended.", $ExitCode)
		EndIf
		;
	Else
		;ConsoleWrite("*** AU3CHECK (1) : ERROR: *** Skipping AU3Check: " & $Au3checkpgm & " Not Found !" & @crlf & @crlf)
		ConsoleWrite("! *** AU3CHECK Error: *** Skipping AU3Check: " & $Au3checkpgm & " Not Found !" & @CRLF & @CRLF)
	EndIf
	FileDelete($TempFile)
EndIf
; if AU3Check parameter was specified than stop the process.
If $Option = "AU3Check" Then Exit
#EndRegion Run AU3Check
#Region Run Obfuscator
; Run Obfuscator when requested.
If Not $InputFileIsUTF16 And $Option = "Compile" And $INP_Run_Obfuscator = "y" Then
	Global $ObfuscatorpgmVer = ""
	Global $Obfuscatorpgm = $SciTE_Dir & "\Obfuscator\Obfuscator.exe"
	Global $Obfuscatorpgmdir
	If FileExists($Obfuscatorpgm) Then
		$Obfuscatorpgmdir = $SciTE_Dir
		$ObfuscatorpgmVer = FileGetVersion($Obfuscatorpgm)
		If $ObfuscatorpgmVer = "0.0.0.0" Then
			$ObfuscatorpgmVer = ""
		Else
			$ObfuscatorpgmVer = "(" & $ObfuscatorpgmVer & ")"
		EndIf
		ProgressSet(7, "Running Obfuscator ...")
		ConsoleWrite(">Running Obfuscator " & $ObfuscatorpgmVer & "  from:" & $Obfuscatorpgmdir & " cmdline:" & $ObfuscatorCmdLine & @CRLF)
		$Pid = Run('"' & $Obfuscatorpgm & '" "' & $ScriptFile_In & '" ' & $ObfuscatorCmdLine, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		$Handle = _ProcessExitCode($Pid)
		$Return_Text = ShowStdOutErr($Pid)
		$ExitCode = _ProcessExitCode($Pid, $Handle)
		_ProcessCloseHandle($Handle)
		StdioClose($Pid)
		; Show the Errors in a MSGBox
;~ 		Write_RC_Console_Msg("Obfuscator ended.", $ExitCode)
		;
		$ScriptFile_In_Obfuscated = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '_Obfuscated' & $ScriptFile_In_Ext
		;
		If $ExitCode > 0 And $ExitCode < 999 Then
			;There were warnings ...   show msbox to make sure they know what they are doing.
			Show_Warnings("Obfuscator Warnings/Errors", StringReplace($Return_Text, @CR, ""))
			$ExitCode = 0
		ElseIf $ExitCode = 999 Then
			Write_RC_Console_Msg("Obfuscator ended with errors, using original scriptfile.", $ExitCode)
			FileCopy($ScriptFile_In, $ScriptFile_In_Obfuscated, 1)
		EndIf
		; change input file to the obfuscated file
		; Run au3check on the obfuscated source
		If $ExitCode < 999 And $INP_Run_AU3Check = "y" Then
			$TempFile = @TempDir & '\au3check.log'
			FileDelete($TempFile)
			If $INP_AU3Check_Parameters <> "" Then
				ConsoleWrite(">Running AU3Check for obfuscated file" & $Au3checkpgmVer & "  params:" & $INP_AU3Check_Parameters & "  from:" & $Au3checkpgmdir & @CRLF)
			Else
				ConsoleWrite(">Running AU3Check for obfuscated file" & $Au3checkpgmVer & "  from:" & $Au3checkpgmdir & @CRLF)
			EndIf
			;---- uses the Beta STDOUT fuunctionality ------------------------------------------
			$Pid = Run('"' & $Au3checkpgm & '" ' & $INP_AU3Check_Parameters & ' -q "' & $ScriptFile_In_Obfuscated & '"', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			$Handle = _ProcessExitCode($Pid)
			$Return_Text = ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			StdioClose($Pid)
			; Show the Errors in a MSGBox
			If $Return_Text <> "" Then
				;ConsoleWrite(">AU3Check Ended with Error(s). rc:" & $exitcode & @crlf)
				Write_RC_Console_Msg("AU3Check Obfuscated code ended.", $ExitCode)
				If $Option <> "AU3Check" And ProcessExists("SciTe.exe") Then
					If $INP_AU3Check_Stop_OnWarning <> "y" And StringInStr($Return_Text, " - 0 error(s)") > 0 Then
					Else
						Show_Warnings("Au3Check errors", StringReplace($Return_Text, @CR, ""))
					EndIf
				EndIf
			Else
				;ConsoleWrite(">AU3Check Ended. No Error(s).   rc:" & $exitcode & @crlf)
				Write_RC_Console_Msg("AU3Check Obfuscated code ended.", $ExitCode)
			EndIf
		EndIf
	Else
		ConsoleWrite("! *** Obfuscator Error: *** Skipping Obfuscator: " & $Obfuscatorpgm & " Not Found !" & @CRLF & @CRLF)
	EndIf
EndIf
#EndRegion Run Obfuscator
#Region Compile the script
; If Compile is the option then
If $Option = "Compile" Then
	#Region Update Resources
	Global $T_Err, $AutoItBin
	;
	; Determine and copy the wanted BIN file
	$AutoItBin = $AUT2EXE_DIR & "\AutoItSC.bin"
	If $INP_UseAnsi = "y" Then
		If FileExists($AUT2EXE_DIR & "\AutoItASC.bin") Then
			$AutoItBin = $AUT2EXE_DIR & "\AutoItASC.bin"
			If FileGetVersion($AUT2EXE_DIR & "\AutoItASC.bin") <> FileGetVersion($AUT2EXE_DIR & "\AutoItSC.bin") Then
				ConsoleWrite("! AutoIt3 ANSI version(" & FileGetVersion($AUT2EXE_DIR & "\AutoItASC.bin") & ") is an older version than the current UNICODE vesion(" & FileGetVersion($AUT2EXE_DIR & "\AutoItSC.bin") & ")! Make sure you are not using incompatible functions." & @CRLF)
			EndIf
		Else
			ConsoleWrite("! AutoIt3 ANSI version not present, defaulting back to standard UNICODE version." & @CRLF)
			$INP_UseAnsi = "n"
			$AutoItBin = $AUT2EXE_DIR & "\AutoItSC.bin"
		EndIf
	ElseIf $INP_UseX64 = "y" Then
		If FileExists($AUT2EXE_DIR & "\AutoItSC_x64.bin") Then
			$AutoItBin = $AUT2EXE_DIR & "\AutoItSC_x64.bin"
		Else
			ConsoleWrite("! AutoIt3 X64 version not present, defaulting back to standard UNICODE version." & @CRLF)
			$INP_UseX64 = "n"
			$AutoItBin = $AUT2EXE_DIR & "\AutoItSC.bin"
		EndIf
	Else
		$AutoItBin = $AUT2EXE_DIR & "\AutoItSC.bin"
	EndIf
	If Not FileExists($AutoItBin) Then $AutoItBin = $AUT2EXE_DIR & "\AutoItSC.bin"
	; Copy Bin file to Temp for updating
	FileCopy($AutoItBin, StringReplace($AutoItBin, $AUT2EXE_DIR, @TempDir), 1)
	Global $PgmVer = FileGetVersion($AutoItBin)
	$AutoItBin = StringReplace($AutoItBin, $AUT2EXE_DIR, @TempDir)
	; Update resources
	While $INP_Resource
		ProgressSet(40, "Creating Resource file.")
		;
		$INP_Res_Language = Number($INP_Res_Language)
		If $INP_Res_Language = 0 Then $INP_Res_Language = 2057
		; create the source of the VERSION resource update file
		If $INP_Resource_Version = 1 Then
			Global $Version_Res_File = ""
			; retrieve the current info when not all fields are filled to preserve those:
			If $INP_Comment = "" Then $INP_Comment = FileGetVersion($AutoItBin, "Comments")
			If $INP_Description = "" Then $INP_Description = FileGetVersion($AutoItBin, "FileDescription")
			If $INP_Fileversion = "" Then $INP_Fileversion = FileGetVersion($AutoItBin)
			If $INP_LegalCopyright = "" Then $INP_LegalCopyright = FileGetVersion($AutoItBin, "LegalCopyright")
			$INP_ProductVersion = FileGetVersion($AutoItBin)
			; Delete current resources for standard languages since new language is requested
			If $INP_Res_Language <> 2057 Then _Res_Update($AutoItBin, "", 16, 1, 2057)
			_Res_Create_RTVersion($Version_Res_File) ; Build the RT_VERSION structure
			_Res_Update($AutoItBin, $Version_Res_File, 16, 1, $INP_Res_Language) ; Update RT_VERSION in the Bin file
			FileDelete($Version_Res_File)
			ConsoleWrite("+> Updated RT_VERSION information." & @CRLF)
		EndIf
		;
		;
		;Update manifest
		$TempFile2 = @TempDir & '\RHManifest.txt'
		If $INP_RES_requestedExecutionLevel <> "" Then
			Global $hTempFile2 = FileOpen($TempFile2, 2)
			FileWriteLine($hTempFile2, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
			FileWriteLine($hTempFile2, '<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">')
			FileWriteLine($hTempFile2, '	<assemblyIdentity')
			FileWriteLine($hTempFile2, '	    type="win32"')
			FileWriteLine($hTempFile2, '	    processorArchitecture="*"')
			FileWriteLine($hTempFile2, '	    version="3.0.0.0"')
			FileWriteLine($hTempFile2, '	    name="AutoIt3"')
			FileWriteLine($hTempFile2, '	/>')
			FileWriteLine($hTempFile2, '	<description>AutoIt v3</description>')
			FileWriteLine($hTempFile2, '')
			FileWriteLine($hTempFile2, '	<!-- Identify the application security requirements. -->')
			FileWriteLine($hTempFile2, '	<trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">')
			FileWriteLine($hTempFile2, '		<security>')
			FileWriteLine($hTempFile2, '			<requestedPrivileges>')
			FileWriteLine($hTempFile2, '				<requestedExecutionLevel')
			FileWriteLine($hTempFile2, ' 				level="' & $INP_RES_requestedExecutionLevel & '"')
			FileWriteLine($hTempFile2, '					uiAccess="false"/>')
			FileWriteLine($hTempFile2, '			</requestedPrivileges>')
			FileWriteLine($hTempFile2, '		</security>')
			FileWriteLine($hTempFile2, '	</trustInfo>')
			FileWriteLine($hTempFile2, '')
			FileWriteLine($hTempFile2, '	<!-- Identify the application dependencies. -->')
			FileWriteLine($hTempFile2, '	<dependency>')
			FileWriteLine($hTempFile2, '		<dependentAssembly>')
			FileWriteLine($hTempFile2, '			<assemblyIdentity')
			FileWriteLine($hTempFile2, '				type="win32"')
			FileWriteLine($hTempFile2, '				name="Microsoft.Windows.Common-Controls"')
			FileWriteLine($hTempFile2, '				version="6.0.0.0"')
			FileWriteLine($hTempFile2, '				language="*"')
			FileWriteLine($hTempFile2, '				processorArchitecture="*"')
			FileWriteLine($hTempFile2, '				publicKeyToken="6595b64144ccf1df"')
			FileWriteLine($hTempFile2, '			/>')
			FileWriteLine($hTempFile2, '		</dependentAssembly>')
			FileWriteLine($hTempFile2, '	</dependency>')
			FileWriteLine($hTempFile2, '</assembly>')
			FileClose($hTempFile2)
			If $INP_Res_Language <> 2057 Then _Res_Update($AutoItBin, "", 24, 1, 2057)
			_Res_Update($AutoItBin, $TempFile2, 24, 1, $INP_Res_Language)
			ConsoleWrite("+> Updated RT_MANIFEST information." & @CRLF)
		EndIf
		;
		;Update ICOs
		; Add original source to Resources
		If $INP_Res_SaveSource = "y" Then
			FileCopy($ScriptFile_In, @TempDir & "\scriptin.tmp", 1)
			_Res_Update($AutoItBin, @TempDir & "\scriptin.tmp", 10, 999, $INP_Res_Language)
			FileDelete(@TempDir & "\scriptin.tmp")
			ConsoleWrite("+> Added Script source to RT_RCDATA,999." & @CRLF)
		EndIf
		; Add ICO's to Resources
		For $x = 1 To $INP_Icons_cnt
			_Res_Update($AutoItBin, $INP_Icons[$x], 3, 200 + $x, $INP_Res_Language)
		Next
		If $INP_Icons_cnt = 1 Then
			ConsoleWrite("> Added Icon to the Output executable." & @CRLF)
		ElseIf $INP_Icons_cnt > 1 Then
			ConsoleWrite("+> Added " & $INP_Icons_cnt & " Icons to the Output executable resources." & @CRLF)
		EndIf
		; Add Files to Resources
		Global $ResFileInfo
		For $x = 1 To $INP_Files_cnt
			$ResFileInfo = StringSplit($INP_Files[$x], ",")
			ReDim $ResFileInfo[4]
			If $ResFileInfo[2] = "" Then $ResFileInfo[2] = 10
			If $ResFileInfo[3] = "" Then $ResFileInfo[3] = $x
			$ResFileInfo[1] = StringReplace($ResFileInfo[1], "\", "\\")
			$ResFileInfo[1] = StringReplace($ResFileInfo[1], "/", "\\")
			_Res_Update($AutoItBin, $ResFileInfo[1], 10, $x, $INP_Res_Language)
		Next
		If $INP_Files_cnt = 1 Then
			ConsoleWrite("+> Adding 1 file to the Output executable." & @CRLF)
		ElseIf $INP_Files_cnt > 1 Then
			ConsoleWrite("+> Adding " & $INP_Files_cnt & " files to the Output executable resources." & @CRLF)
		EndIf
		;
		Write_RC_Console_Msg("Resource updating finished.")
		ExitLoop
	WEnd
	#EndRegion Update Resources
	#Region Run Aut2Exe
	;  Run aut2exe to compile the script
	ProgressSet(50, "Running Aut2exe.exe.")
	; Set the proper compile option
	;
	; Set the UPX flag only for None x64 scripts
	If $INP_UseUpx = "y" And ($INP_UseX64 = "n" Or $INP_UseAnsi = "y") Then
		$s_CMDLine &= " /pack"
	Else
		$s_CMDLine &= " /nopack"
	EndIf
	; Set the CUI / GUI
	If $INP_Change2CUI = "y" Then $s_CMDLine &= " /Console"
	; Add the (optionally RES modified) BIN to the commandline
	If $AutoItBin <> "" And FileExists($AutoItBin) Then $s_CMDLine &= ' /Bin ' & FileGetShortName($AutoItBin) & ''
	If $Debug Then ConsoleWrite(">*** AUT2EXE:" & '"' & $AUT2EXE_PGM & '"' & $s_CMDLine & " " & @CRLF)
	;
	ConsoleWrite(">Running:(" & $PgmVer & "):" & $AUT2EXE_PGM & " " & $s_CMDLine & @CRLF)
	$Pid = Run('"' & $AUT2EXE_PGM & '"' & $s_CMDLine, "", -1, $STDERR_CHILD + $STDOUT_CHILD)
	If $Pid Then
		$Handle = _ProcessExitCode($Pid)
		While ProcessExists($Pid)
			Sleep(25)
		WEnd
		; Show console output
		ShowStdOutErr($Pid)
		$ExitCode = _ProcessExitCode($Pid, $Handle)
		_ProcessCloseHandle($Handle)
		;ConsoleWrite(">Aut2exe.exe ended.  rc:" & $exitcode & @crlf)
	EndIf
	;
	If Not $Pid Or Not FileExists($ScriptFile_Out) Then
		Write_RC_Console_Msg("Aut2exe.exe ended errors because the target exe wasn't created, abandon build.", 9999)
		Exit
	Else
		Write_RC_Console_Msg("Aut2exe.exe ended.", $ExitCode)
		Write_RC_Console_Msg("Created program:" & $ScriptFile_Out, "", "+")
	EndIf
	; remove the temp bin file
	FileDelete($AutoItBin)
	;
	If $INP_UseAnsi = "n" Then
		If $INP_UseX64 = "n" Then
			ConsoleWrite("->Warning: This is an Unicode compiled script and will not run on Win9x/ME." & @CRLF)
		Else
			ConsoleWrite("->Warning: This is an X64 compiled script and will only work on a system with a X64 OS." & @CRLF)
		EndIf
	EndIf
	;
	#EndRegion Run Aut2Exe
	#Region Run cvsWrapper
	; Check if the Version needs updating
	If $INP_Fileversion_AutoIncrement = "p" Then
		If MsgBox(262144 + 4096 + 4, "AutoIt3Wrappper", "Do you want to increase the version number of the source to:" & @LF & $INP_Fileversion_New, 10) = 6 Then
			$INP_Fileversion_AutoIncrement = 'y'
		Else
			$INP_Fileversion_New = $INP_Fileversion
		EndIf
	EndIf
	; run cvsWrapper
	If $INP_Run_cvsWrapper = 'y' Or ($INP_Run_cvsWrapper = 'v' And $INP_Fileversion_AutoIncrement = 'y') Then
		If FileExists($SciTE_Dir & "\cvsWrapper\cvsWrapper.exe") Then
			ProgressSet(92, "Running cvsWrapper.")
			$INP_cvsWrapper_Parameters = Convert_Variables($INP_cvsWrapper_Parameters, 1)
			$Pid = Run('"' & $SciTE_Dir & '\cvsWrapper\cvsWrapper.exe" "' & $ScriptFile_In & '" ' & $INP_cvsWrapper_Parameters, "", -1, $STDERR_CHILD + $STDOUT_CHILD)
			$Handle = _ProcessExitCode($Pid)
			ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			;ConsoleWrite(">Aut2exe.exe ended.  rc:" & $exitcode & @crlf)
			Write_RC_Console_Msg("cvsWrapper.exe ended.", $ExitCode)
		Else
			ConsoleWrite("- cvsWrapper program not found. skipping this step")
		EndIf
	EndIf
	#EndRegion Run cvsWrapper
	#Region Run RunAfter Steps
	WinActivate($ProcessBar_Title)
	$INP_Run_After = StringSplit($INP_Run_After, "|")
	For $x = 1 To $INP_Run_After[0]
		If StringStripWS($INP_Run_After[$x], 3) <> "" Then
			ProgressSet(95, "Running :" & $INP_Run_After[$x])
			; translate possible %..% to the actual values
			$INP_Run_After[$x] = Convert_Variables($INP_Run_After[$x])
			ConsoleWrite(">Running:" & $INP_Run_After[$x] & @CRLF)
			$Pid = Run(@ComSpec & ' /C ' & $INP_Run_After[$x] & '', '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			$Handle = _ProcessExitCode($Pid)
			ShowStdOutErr($Pid)
			$ExitCode = _ProcessExitCode($Pid, $Handle)
			_ProcessCloseHandle($Handle)
			ConsoleWrite(">" & $INP_Run_After[$x] & " Ended   rc:" & $ExitCode & @CRLF)
		EndIf
	Next
	#EndRegion Run RunAfter Steps
	#Region Update FileVersion
	; Increment the #Compiler_Res_Fileversion= value in the source file
	;
	If $INP_Fileversion_AutoIncrement = 'y' Then
		If $INP_Fileversion = "" Then
			ConsoleWrite("- Failed to Updated the Source Version. The Source doesnt contain the #Compiler_Res_Fileversion directive." & @CRLF)
		Else
;~ 			; Ask SciTE for the current buffer/filename
;~ 			$CurSciTEFile = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askfilename:")
;~ 			$CurSciTEFile = StringReplace($CurSciTEFile, "filename:", "")
;~ 			$CurSciTEFile = StringReplace($CurSciTEFile, "\\", "\")
;~ 			; when its the correct filename then do a replace via SciTE Director interface and jump to line 1
;~ 			If $CurSciTEFile = $ScriptFile_In Then
;~ 				$CurSciTELine = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:SelectionStartLine")
;~ 				; Reload file
;~ 				$sCmd = "open:" & StringReplace($CurSciTEFile, "\", "\\")
;~ 				; Find current verion
;~ 				SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
;~ 				$FindVer = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "find:" & $INP_Fileversion)
;~ 				$CurSelection = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:CurrentSelection")
;~ 				If $CurSelection = $INP_Fileversion Then
;~ 					If $INP_Fileversion_New = "" Then $INP_Fileversion_New = $INP_Fileversion
;~ 					$sCmd = "replaceall:" & $INP_Fileversion & "\000" & $INP_Fileversion_New
;~ 					SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
;~ 					ConsoleWrite(">Updated the Source Version to:" & $INP_Fileversion_New & ".." & @CRLF)
;~ 				EndIf
;~ 				; Jump back to the original select line
;~ 				$sCmd = "goto:" & $CurSciTELine
;~ 				SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
;~ 				$sCmd = "saveas:" & StringReplace($CurSciTEFile, "\", "\\")
;~ 			Else
			If $INP_Fileversion_New <> "" Then
				$ToTalFile = @CRLF & FileRead($ScriptFile_In)
				;$ToTalFile = StringReplace($ToTalFile, $INP_Fileversion, $INP_Fileversion_New, 1)
				; added & chr(61) & to avoid replacing this statement when the version is updated
				$ToTalFile = StringRegExpReplace($ToTalFile, '(?i)' & @CRLF & '(\h?)#AutoIt3Wrapper_Res_Fileversion(\h*?)=(.*?)' & @CRLF, @CRLF & '#AutoIt3Wrapper_Res_Fileversion=' & $INP_Fileversion_New & @CRLF)
				$H_Outf = FileOpen($ScriptFile_In, 2)
				FileWrite($H_Outf, StringMid($ToTalFile, 3))
				FileClose($H_Outf)
				ConsoleWrite(">Updated the Source Version to:" & $INP_Fileversion_New & "..." & @CRLF)
			EndIf
;~ 			EndIf
		EndIf
	EndIf
	#EndRegion Update FileVersion
EndIf
#EndRegion Compile the script
#Region Run the Script
If $Option = "Run" Then
	ProgressOff()
	If Not FileExists($AutoIT3_PGM) Then
		ConsoleWrite('!>Error: program "' & $AutoIT3_PGM & '" is missing. Check your installation.' & @CRLF)
		Exit 999
	EndIf
	$s_CMDLine = StringReplace($s_CMDLine, "/ErrorStdOut", "")
	ConsoleWrite('>Running:(' & FileGetVersion($AutoIT3_PGM) & "):" & $AutoIT3_PGM & ' "' & $ScriptFile_In & '" ' & $s_CMDLine & @CRLF)
	;Add debug statements
	Global $sDebugFile = ""
	If $INP_Run_Debug_Mode Then
		ConsoleWrite('!> Starting in DebugMode..' & @CRLF)
		ConsoleWrite('Line: @error-@extended: Line syntax' & @CRLF)
		RunAutoItDebug($ScriptFile_In, $sDebugFile)
		; Run your script in debug mode
		$Pid = Run('"' & $AutoIT3_PGM & '" /ErrorStdOut "' & $sDebugFile & '" ' & $s_CMDLine, "", -1, $STDERR_CHILD + $STDOUT_CHILD)
	Else
		; Run your script
		$Pid = Run('"' & $AutoIT3_PGM & '" /ErrorStdOut "' & $ScriptFile_In & '" ' & $s_CMDLine, "", -1, $STDERR_CHILD + $STDOUT_CHILD)
	EndIf
	; Run second version as Watcher to kill this The running AutoItscript when AutoIt3Wrapper is killed.
	Global $CW = Run(@ScriptFullPath & " /Watcher " & @AutoItPID & " " & $Pid)
	$Handle = _ProcessExitCode($Pid)
	ShowStdOutErr($Pid)
	$ExitCode = _ProcessExitCode($Pid, $Handle)
	_ProcessCloseHandle($Handle)
	;ConsoleWrite($pref & ">AutoIT3.exe ended.  rc:" & $exitcode & @crlf)
	Write_RC_Console_Msg("AutoIT3.exe ended.", $ExitCode)
	ProcessWaitClose($CW)
	If $INP_Run_Debug_Mode Then FileDelete($sDebugFile)
	Exit $ExitCode ; exit with the returncode of the run script
EndIf
#EndRegion Run the Script
#Region End AutoIt3Wrapper
; End of the program
ProgressOff()
; Done
Exit
#EndRegion End AutoIt3Wrapper
#Region Functions
;Helper function to compare the Version dates
Func _Compare_Date_GT($date1, $Date2)
	Local $Id1 = StringSplit($date1, "/")
	Local $Id2 = StringSplit($Date2, "/")
	ReDim $Id1[4]
	ReDim $Id2[4]
	$date1 = $Id1[3] & "/" & $Id1[1] & "/" & $Id1[2]
	$Date2 = $Id2[3] & "/" & $Id2[1] & "/" & $Id2[2]
	If Not _DateIsValid($date1) Then Return 0
	If Not _DateIsValid($Date2) Then Return 0
	Return _DateDiff("d", $Date2, $date1)
EndFunc   ;==>_Compare_Date_GT
;
Func _ProcessCloseHandle($h_Process)
	; Close the process handle of a PID
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $h_Process)
	If Not @error Then Return 1
	Return 0
EndFunc   ;==>_ProcessCloseHandle
;===============================================================================
;
; Function Name:    _ProcessExitCode()
; Description:      Returns a handle/exitcode from use of Run().
; Parameter(s):     $i_Pid        - ProcessID returned from a Run() execution
;                   $h_Process    - Process handle
; Requirement(s):   None
; Return Value(s):  On Success - Returns Process handle while Run() is executing
;                                (use above directly after Run() line with only PID parameter)
;                              - Returns Process Exitcode when Process does not exist
;                                (use above with PID and Process Handle parameter returned from first UDF call)
;                   On Failure - 0
; Author(s):        MHz (Thanks to DaveF for posting these DllCalls in Support Forum)
;
;===============================================================================
;
Func _ProcessExitCode($i_Pid, $h_Process = 0)
	; 0 = Return Process Handle of PID else use Handle to Return Exitcode of a PID
	Local $v_Placeholder
	If Not IsArray($h_Process) Then
		; Return the process handle of a PID
		$h_Process = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $i_Pid)
		If Not @error Then Return $h_Process
	Else
		; Return Process Exitcode of PID
		$h_Process = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $h_Process[0], 'int*', $v_Placeholder)
		If Not @error Then Return $h_Process[2]
	EndIf
	Return 0
EndFunc   ;==>_ProcessExitCode
;
; Removes any dead icons from the notification area.
; Parameters:
;    $nDelay - IN/OPTIONAL - The delay to wait for the notification area to expand with Windows XP's
;        "Hide Inactive Icons" feature (In milliseconds).
; Returns:
;    Sets @error on failure:
;        1 - Tray couldn't be found.
;        2 - DllCall error.
; ===================================================================
Func _RefreshSystemTray($nDelay = 1000)
	; Save Opt settings
	Local $oldMatchMode = Opt("WinTitleMatchMode", 4)
	Local $oldChildMode = Opt("WinSearchChildren", 1)
	Local $error = 0
	Do; Pseudo loop
		Local $hWnd = WinGetHandle("classname=TrayNotifyWnd")
		If @error Then
			$error = 1
			ExitLoop
		EndIf
		
		Local $hControl = ControlGetHandle($hWnd, "", "Button1")
		
		; We're on XP and the Hide Inactive Icons button is there, so expand it
		If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible", "") Then
			ControlClick($hWnd, "", $hControl)
			Sleep($nDelay)
		EndIf
		
		Local $posStart = MouseGetPos()
		Local $posWin = WinGetPos($hWnd)
		
		Local $y = $posWin[1]
		While $y < $posWin[3] + $posWin[1]
			Local $x = $posWin[0]
			While $x < $posWin[2] + $posWin[0]
				DllCall("user32.dll", "int", "SetCursorPos", "int", $x, "int", $y)
				If @error Then
					$error = 2
					ExitLoop 3; Jump out of While/While/Do
				EndIf
				$x = $x + 8
			WEnd
			$y = $y + 8
		WEnd
		DllCall("user32.dll", "int", "SetCursorPos", "int", $posStart[0], "int", $posStart[1])
		; We're on XP so we need to hide the inactive icons again.
		If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible", "") Then
			ControlClick($hWnd, "", $hControl)
		EndIf
	Until 1
	
	; Restore Opt settings
	Opt("WinTitleMatchMode", $oldMatchMode)
	Opt("WinSearchChildren", $oldChildMode)
	SetError($error)
EndFunc   ;==>_RefreshSystemTray
;
;
Func _Res_Create_RTVersion_BuildStringTableEntry($Key, $value)
	Local $padding = 1 - Mod(6 + StringLen($Key) + 1, 2)
	Local $padding2 = 1 - Mod(6 + StringLen($Key) + 1 + $padding + StringLen($value) + 1, 2)
	Global $p_VS_String = DllStructCreate( _
			"short   wLength;" & _                                       ;Specifies the length, in bytes, of this String structure.
			"short   wValueLength;" & _                                  ;Specifies the size, in words, of the Value member.
			"short   wType;" & _                                         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"wchar   szKey[" & StringLen($Key) + 1 + $padding & "];" & _ ;Specifies an arbitrary Unicode string. The szKey member can be one or more of the following values. These values are guidelines only.
			"wchar   Value[" & StringLen($value) + 1 + $padding2 & "]") ;Specifies a zero-terminated string. See the szKey member description for more information.
	DllStructSetData($p_VS_String, "Wlength", DllStructGetSize($p_VS_String) - $padding2 * 2)
	DllStructSetData($p_VS_String, "wValueLength", StringLen($value) + 1)
	DllStructSetData($p_VS_String, "wType", 1)
	DllStructSetData($p_VS_String, "szKey", $Key)
	DllStructSetData($p_VS_String, "Value", $value)
	Return StringMid(DllStructGetData(DllStructCreate("byte[" & DllStructGetSize($p_VS_String) & "]", DllStructGetPtr($p_VS_String)), 1), 3)
EndFunc   ;==>_Res_Create_RTVersion_BuildStringTableEntry
;
;
Func _Res_Create_RTVersion(ByRef $OutResPath)
	; construct the Stringtable Entries in a Binary string for easy concatenation
	Local $Res_StringTable_Children = "0x"
;~ 	$Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("CompiledScript", $INP_CompiledScript)
	$Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("FileVersion", $INP_Fileversion)
	If $INP_Comment <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("Comments", $INP_Comment)
	If $INP_Description <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("FileDescription", $INP_Description)
	If $INP_LegalCopyright <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry("LegalCopyright", $INP_LegalCopyright)
	If $INP_FieldName1 & $INP_FieldValue1 <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry($INP_FieldName1, $INP_FieldValue1)
	If $INP_FieldName2 & $INP_FieldValue2 <> "" Then $Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry($INP_FieldName2, $INP_FieldValue2)
	For $U = 1 To $INP_RES_FieldCount
		If $INP_FieldName[$U] <> "" And $INP_FieldValue[$U] <> "" Then
			$INP_FieldValue[$U] = Convert_Variables($INP_FieldValue[$U])
			$Res_StringTable_Children &= _Res_Create_RTVersion_BuildStringTableEntry($INP_FieldName[$U], $INP_FieldValue[$U])
		EndIf
	Next
	;
	; construct the Stringtable
	Local $p_VS_StringTable = DllStructCreate( _
			"short   wLength;" & _       ;Specifies the length, in bytes, of this StringTable structure, including all structures indicated by the Children member.
			"short   wValueLength;" & _  ;This member is always equal to zero.
			"short   wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"byte    szKey[16];" & _     ;Specifies an 8-digit hexadecimal number stored as a Unicode string. The four most significant digits represent the language identifier. The four least significant digits represent the code page for which the data is formatted. Each Microsoft Standard Language identifier contains two parts: the low-order 10 bits specify the major language, and the high-order 6 bits specify the sublanguage. For a table of valid identifiers see .
			"byte    Padding[2];" & _    ;Contains as many zero words as necessary to align the Children member on a 32-bit boundary.
			"byte    Children[" & (StringLen($Res_StringTable_Children) - 2) / 2 & "]") ;Specifies an array of one or more String structures.
	DllStructSetData($p_VS_StringTable, "Wlength", DllStructGetSize($p_VS_StringTable))
	DllStructSetData($p_VS_StringTable, "wValueLength", 0)
	DllStructSetData($p_VS_StringTable, "wType", 1)
	DllStructSetData($p_VS_StringTable, "szKey", StringToBinary(Hex($INP_Res_Language, 4) & '04b0', 2))
	DllStructSetData($p_VS_StringTable, "Children", Binary($Res_StringTable_Children))
	;
	; construct the StringFileInfo
	Local $p_VS_StringFileInfo = DllStructCreate( _
			"short  wLength;" & _      ;Specifies the length, in bytes, of the entire StringFileInfo block, including all structures indicated by the Children member.
			"short  wValueLength;" & _ ;This member is always equal to zero.
			"short  wType;" & _        ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"WCHAR  szKey[15];" & _    ;Contains the Unicode string "StringFileInfo".
			"byte   Children[" & DllStructGetSize($p_VS_StringTable) & "]") ;Contains an array of one or mcore StringTable structures. Each StringTable structure's szKey member indicates the appropriate language and code page for displaying the text in that StringTable structure.
	DllStructSetData($p_VS_StringFileInfo, "Wlength", DllStructGetSize($p_VS_StringFileInfo))
	DllStructSetData($p_VS_StringFileInfo, "wValueLength", 0)
	DllStructSetData($p_VS_StringFileInfo, "wType", 1)
	DllStructSetData($p_VS_StringFileInfo, "szKey", "StringFileInfo")
	Local $p_VS_StringTable_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_StringTable) & "]", DllStructGetPtr($p_VS_StringTable))
	DllStructSetData($p_VS_StringFileInfo, "Children", DllStructGetData($p_VS_StringTable_Total, 1))
	;
	; construct the Var
	Local $p_VS_Var = DllStructCreate( _
			"short  wLength;" & _       ;Specifies the length, in bytes, of the Var structure.
			"short  wValueLength;" & _  ;Specifies the length, in bytes, of the Value member.
			"short  wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"WCHAR  szKey[12];" & _     ;Contains the Unicode string "Translation".
			"char  Padding[1];" & _     ;Contains as many zero words as necessary to align the Value member on a 32-bit boundary.
			"short  lang;" & _          ;Specifies an array of one or more values that are language and code page identifier pairs. For additional information, see the following Remarks section.
			"short  lang2") ;Specifies an array of one or more values that are language and code page identifier pairs. For additional information, see the following Remarks section.
	DllStructSetData($p_VS_Var, "Wlength", DllStructGetSize($p_VS_Var))
	DllStructSetData($p_VS_Var, "wValueLength", 4)
	DllStructSetData($p_VS_Var, "wType", 0)
	DllStructSetData($p_VS_Var, "szKey", "Translation")
	DllStructSetData($p_VS_Var, "lang", $INP_Res_Language)
	DllStructSetData($p_VS_Var, "lang2", 0x04B0)
	;
	; construct the VarFileInfo
	Local $p_VS_VarFileInfo = DllStructCreate( _
			"short  wLength;" & _       ;Specifies the length, in bytes, of the entire VarFileInfo block, including all structures indicated by the Children member.
			"short  wValueLength;" & _  ;This member is always equal to zero.
			"short  wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"WCHAR szKey[12];" & _      ;Contains the Unicode string "VarFileInfo".
			"char  Padding[2];" & _     ;Contains as many zero words as necessary to align the Value member on a 32-bit boundary.
			"Byte   Children[" & DllStructGetSize($p_VS_Var) & "]") ;Specifies a Var structure that typically contains a list of languages that the application or DLL supports.
	DllStructSetData($p_VS_VarFileInfo, "Wlength", DllStructGetSize($p_VS_VarFileInfo))
	DllStructSetData($p_VS_VarFileInfo, "wValueLength", 0)
	DllStructSetData($p_VS_VarFileInfo, "wType", 1)
	DllStructSetData($p_VS_VarFileInfo, "szKey", "VarFileInfo")
	Local $p_VS_Var_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_Var) & "]", DllStructGetPtr($p_VS_Var))
	DllStructSetData($p_VS_VarFileInfo, "Children", DllStructGetData($p_VS_Var_Total, 1))
	;
	; construct the FIXEDFILEINFO
	Local $p_VS_FIXEDFILEINFO = DllStructCreate( _
			"DWORD dwSignature;" & _
			"DWORD dwStrucVersion;" & _
			"DWORD dwFileVersionMS;" & _
			"DWORD dwFileVersionLS;" & _
			"DWORD dwProductVersionMS;" & _
			"DWORD dwProductVersionLS;" & _
			"DWORD dwFileFlagsMask;" & _
			"DWORD dwFileFlags;" & _
			"DWORD dwFileOS;" & _
			"DWORD dwFileType;" & _
			"DWORD dwFileSubtype;" & _
			"DWORD dwFileDateMS;" & _
			"DWORD dwFileDateLS")
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwSignature", 0xFEEF04BD)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwStrucVersion", 0x00010000)
	$INP_Fileversion = Valid_FileVersion($INP_Fileversion)
	Local $tFileversion = StringSplit($INP_Fileversion, ".")
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileVersionMS", Number("0x" & Hex($tFileversion[1], 4) & Hex($tFileversion[2], 4)))
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileVersionLS", Number("0x" & Hex($tFileversion[3], 4) & Hex($tFileversion[4], 4)))
	$tFileversion = StringSplit($INP_ProductVersion, ".")
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwProductVersionMS", Number("0x" & Hex($tFileversion[1], 4) & Hex($tFileversion[2], 4)))
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwProductVersionLS", Number("0x" & Hex($tFileversion[3], 4) & Hex($tFileversion[4], 4)))
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileFlagsMask", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileFlags", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileOS", 0x00004)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileType", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileSubtype", 0)
	DllStructSetData($p_VS_FIXEDFILEINFO, "dwFileDateLS", 0)
	;
	; construct the Final VERSIONINFO
	Local $p_VS_VERSIONINFO = DllStructCreate( _
			"short  wLength;" & _       ;Specifies the length, in bytes, of the VS_VERSIONINFO structure. This length does not include any padding that aligns any subsequent version resource data on a 32-bit boundary.
			"short  wValueLength;" & _  ;Specifies the length, in bytes, of the Value member. This value is zero if there is no Value member associated with the current version structure.
			"short  wType;" & _         ;Specifies the type of data in the version resource. This member is 1 if the version resource contains text data and 0 if the version resource contains binary data.
			"wchar  szKey[16];" & _     ;Contains the Unicode string "VS_VERSION_INFO".
			"wchar  Padding1[1];" & _   ;Contains as many zero words as necessary to align the Value member on a 32-bit boundary.
			"byte   value[" & DllStructGetSize($p_VS_FIXEDFILEINFO) & "];" & _     ;Contains a VS_FIXEDFILEINFO structure that specifies arbitrary data associated with this VS_VERSIONINFO structure. The wValueLength member specifies the length of this member; if wValueLength is zero, this member does not exist.
			"byte   Children[" & DllStructGetSize($p_VS_StringFileInfo) & "];" & _ ;Specifies an array of zero or one StringFileInfo structures, and
			"byte   Children2[" & DllStructGetSize($p_VS_VarFileInfo) & "]") ;          zero or one VarFileInfo structures that are children of the current VS_VERSIONINFO structure.
	DllStructSetData($p_VS_VERSIONINFO, "Wlength", DllStructGetSize($p_VS_VERSIONINFO))
	DllStructSetData($p_VS_VERSIONINFO, "wValueLength", DllStructGetSize($p_VS_FIXEDFILEINFO))
	DllStructSetData($p_VS_VERSIONINFO, "wType", 0)
	DllStructSetData($p_VS_VERSIONINFO, "szKey", "VS_VERSION_INFO")
	; Add the VS_FIXEDFILEINFO structure
	Local $p_VS_FIXEDFILEINFO_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_FIXEDFILEINFO) & "]", DllStructGetPtr($p_VS_FIXEDFILEINFO))
	DllStructSetData($p_VS_VERSIONINFO, "value", DllStructGetData($p_VS_FIXEDFILEINFO_Total, 1))
	; Add the VS_StringFileInfo structure
	Local $p_VS_StringFileInfo_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_StringFileInfo) & "]", DllStructGetPtr($p_VS_StringFileInfo))
	DllStructSetData($p_VS_VERSIONINFO, "Children", DllStructGetData($p_VS_StringFileInfo_Total, 1))
	; Add the VarFileInfo structure
	Local $p_VS_VarFileInfo_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_VarFileInfo) & "]", DllStructGetPtr($p_VS_VarFileInfo))
	DllStructSetData($p_VS_VERSIONINFO, "Children2", DllStructGetData($p_VS_VarFileInfo_Total, 1))
	; Write the Whole structure to a RES file
	Local $p_VS_VERSIONINFO_Total = DllStructCreate("byte Children[" & DllStructGetSize($p_VS_VERSIONINFO) & "]", DllStructGetPtr($p_VS_VERSIONINFO))
	#forceref $OutResPath
	If $OutResPath = "" Then $OutResPath = @TempDir & "\temp.res"
	Local $Fh = FileOpen($OutResPath, 2 + 16)
	FileWrite($Fh, DllStructGetData($p_VS_VERSIONINFO_Total, 1))
	FileClose($Fh)
EndFunc   ;==>_Res_Create_RTVersion
;
;
; Call UpdateResource DllCalls to update the requested resource with the provided RES or ICO file.
;
Func _Res_Update($Filename, $InpResFile, $RSection, $RType = 1, $RLanguage = 2057)
	Local $hDll, $result, $rh, $hFile, $tSize, $tBuffer, $pBuffer, $poBuffer, $bread = 0
	;
	; Remove requested Section from the program resources.
	If $InpResFile = "" Then
		; No resource file defined thus delete the existing resource
		$tBuffer = DllStructCreate("char Text[1]") ; Create the buffer.
		DllStructSetData($tBuffer, 1, Binary("0x00"))
		$poBuffer = DllStructGetPtr($tBuffer)
		$tSize = 0
		$hDll = DllOpen("kernel32.dll")
		$result = DllCall($hDll, "ptr", "BeginUpdateResource", "str", $Filename, "int", 0)
		$rh = $result[0]
		$result = DllCall($hDll, "int", "UpdateResource", "ptr", $rh, "Long", $RSection, "Long", $RType, "short", $RLanguage, "ptr", $poBuffer, 'dword', $tSize)
		$result = DllCall($hDll, "int", "EndUpdateResource", "ptr", $rh, "int", 0)
		DllClose($hDll)
		Return
	EndIf
	; Make sure the input res file exists
	If Not FileExists($InpResFile) Then
		Write_RC_Console_Msg("Recourse Update skipped: missing Resfile :" & $InpResFile, "", "+")
		Return
	EndIf
	;
	; Open the Resource File
	$hFile = _WinAPI_CreateFile($InpResFile, 2, 2)
	If Not $hFile Then
		Write_RC_Console_Msg("Recourse Update skipped: error opening Resfile :" & $InpResFile, "", "+")
		Return
	EndIf
	;
	; Process the different Update types
	$hDll = DllOpen("kernel32.dll")
	Switch $RSection
		Case 3 ; *** RT_ICON
			;ICO section
			$tSize = FileGetSize($InpResFile) - 6
			Local $tB_Input_Header = DllStructCreate("short res;short type;short ImageCount;char rest[" & $tSize + 1 & "]") ; Create the buffer.
			Local $pB_Input_Header = DllStructGetPtr($tB_Input_Header)
			_WinAPI_ReadFile($hFile, $pB_Input_Header, FileGetSize($InpResFile), $bread, 0)
			If $hFile Then _WinAPI_CloseHandle($hFile)
			; Read input file header
			Local $IconType = DllStructGetData($tB_Input_Header, "Type")
			Local $IconCount = DllStructGetData($tB_Input_Header, "ImageCount")
			; Created IconGroup Structure
			Local $tB_IconGroupHeader = DllStructCreate("short res;short type;short ImageCount;char rest[" & $IconCount * 14 & "]") ; Create the buffer.
			Local $pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader)
			DllStructSetData($tB_IconGroupHeader, "Res", 0)
			DllStructSetData($tB_IconGroupHeader, "Type", $IconType)
			DllStructSetData($tB_IconGroupHeader, "ImageCount", $IconCount)
			; process all internal Icons
			For $x = 1 To $IconCount
				; Set pointer correct in the input struct
				Local $pB_Input_IconHeader = DllStructGetPtr($tB_Input_Header, 4) + ($x - 1) * 16
				Local $tB_Input_IconHeader = DllStructCreate("byte Width;byte Heigth;Byte Colors;Byte res;Short Planes;Short BitPerPixel;dword ImageSize;dword ImageOffset", $pB_Input_IconHeader) ; Create the buffer.
				; get info form the input
				Local $IconWidth = DllStructGetData($tB_Input_IconHeader, "Width")
				Local $IconHeigth = DllStructGetData($tB_Input_IconHeader, "Heigth")
				Local $IconColors = DllStructGetData($tB_Input_IconHeader, "Colors")
				Local $IconPlanes = DllStructGetData($tB_Input_IconHeader, "Planes")
				Local $IconBitPerPixel = DllStructGetData($tB_Input_IconHeader, "BitPerPixel")
				Local $IconImageSize = DllStructGetData($tB_Input_IconHeader, "ImageSize")
				Local $IconImageOffset = DllStructGetData($tB_Input_IconHeader, "ImageOffset")
				; Update the ICO Group header struc
				$pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader, 4) + ($x - 1) * 14
				Local $tB_GroupIcon = DllStructCreate("byte Width;byte Heigth;Byte Colors;Byte res;Short Planes;Short BitPerPixel;dword ImageSize;byte ResourceID", $pB_IconGroupHeader) ; Create the buffer.
				DllStructSetData($tB_GroupIcon, "Width", $IconWidth)
				DllStructSetData($tB_GroupIcon, "Heigth", $IconHeigth)
				DllStructSetData($tB_GroupIcon, "Colors", $IconColors)
				DllStructSetData($tB_GroupIcon, "res", 0)
				DllStructSetData($tB_GroupIcon, "Planes", $IconPlanes)
				DllStructSetData($tB_GroupIcon, "BitPerPixel", $IconBitPerPixel)
				DllStructSetData($tB_GroupIcon, "ImageSize", $IconImageSize)
				$IconResBase += 1
				DllStructSetData($tB_GroupIcon, "ResourceID", $IconResBase)
				; Get data pointer
				Local $pB_IconData = DllStructGetPtr($tB_Input_Header) + $IconImageOffset
				; Begin resource Update
				$result = DllCall($hDll, "ptr", "BeginUpdateResource", "str", $Filename, "int", 0)
				$rh = $result[0]
				; add Icon
				$result = DllCall($hDll, "int", "UpdateResource", "ptr", $rh, "Long", 3, "Long", $IconResBase, "short", $RLanguage, "ptr", $pB_IconData, 'dword', $IconImageSize)
				If $result[0] <> 1 Then ConsoleWrite('UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
				$result = DllCall($hDll, "int", "EndUpdateResource", "ptr", $rh, "int", 0)
				If $result[0] <> 1 Then ConsoleWrite('EndUpdateResource: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
			Next
			; Add Icongroup entry
			$pB_IconGroupHeader = DllStructGetPtr($tB_IconGroupHeader)
			; Begin resource Update
			$result = DllCall($hDll, "ptr", "BeginUpdateResource", "str", $Filename, "int", 0)
			$rh = $result[0]
			$result = DllCall($hDll, "int", "UpdateResource", "ptr", $rh, "Long", 14, "Long", $RType, "short", $RLanguage, "ptr", $pB_IconGroupHeader, 'dword', DllStructGetSize($tB_IconGroupHeader))
			If $result[0] <> 1 Then ConsoleWrite('UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
			$result = DllCall($hDll, "int", "EndUpdateResource", "ptr", $rh, "int", 0)
			If $result[0] <> 1 Then ConsoleWrite('EndUpdateResource: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
			
		Case 10, 16, 24 ; *** RT_RCDATA, RT_VERSION and RT_MANIFEST
			; Begin resource Update
			$result = DllCall($hDll, "ptr", "BeginUpdateResource", "str", $Filename, "int", 0)
			$rh = $result[0]
			$tSize = FileGetSize($InpResFile)
			$tBuffer = DllStructCreate("char Text[" & $tSize & "]") ; Create the buffer.
			$pBuffer = DllStructGetPtr($tBuffer)
			_WinAPI_ReadFile($hFile, $pBuffer, FileGetSize($InpResFile), $bread, 0)
			If $hFile Then _WinAPI_CloseHandle($hFile)
			If $bread > 0 Then
				$result = DllCall($hDll, "int", "UpdateResource", "ptr", $rh, "Long", $RSection, "Long", $RType, "short", $RLanguage, "ptr", $pBuffer, 'dword', $tSize)
				If $result[0] <> 1 Then ConsoleWrite('UpdateResources: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
			EndIf
			$result = DllCall($hDll, "int", "EndUpdateResource", "ptr", $rh, "int", 0)
			If $result[0] <> 1 Then ConsoleWrite('EndUpdateResource: $result[0] = ' & $result[0] & " - LastError:" & _WinAPI_GetLastError() & ":" & _WinAPI_GetLastErrorMessage())
	EndSwitch
	;
	DllClose($hDll)
	;
EndFunc   ;==>_Res_Update
;
; Add all needed standard Constants Include files
Func Add_Constants()
	ConsoleWrite("+>Check for missing standard constants/udf include files:")
	Local $ScriptData, $Stripped_ScriptData
	Local $count = 0
	Local $Lines2Add
	; Read the script into a variable
	$ScriptData = @CRLF & FileRead($ScriptFile_In)
	; Strip all comments (pulled from Smoke_N example code)
	$Stripped_ScriptData = StringRegExpReplace($ScriptData & @CRLF, "(?s)(?i)(\s*#cs\s*.+?\#ce\s*)(\r\n)", "\2")
	$Stripped_ScriptData = StringRegExpReplace($Stripped_ScriptData, "(?s)(?i)" & '("")|(".*?")|' & "('')|('.*?')|" & "(\s*;.*?)(\r\n)", "\1\2\3\4\6")
	$Stripped_ScriptData = StringRegExpReplace($Stripped_ScriptData, "(\r\n){2,}", @CRLF)
	;
	Local $includes = _FileListToArray($INP_AutoitDir & "\include", "*Constants*.au3")
	Local $AddInclude = 0
	For $i = 1 To UBound($includes) - 1
		; don't include GUIConstants.au3
		If $includes[$i] = "GUIConstants.au3" Then ContinueLoop
		; Skip already included Include files
		If StringRegExp($Stripped_ScriptData, "(?i)(?s)#include(\s*?)<" & $includes[$i] & ">", 0) Then ContinueLoop
		$AddInclude = 0
		; Get all Constants from include file into Array
		Local $ConstArray = StringRegExp(FileRead($INP_AutoitDir & "\include\" & $includes[$i]), "(?i)\n[\s]*Global[\s]*Const[\s]*(.*?) = ", 3)
		For $j = 0 To UBound($ConstArray) - 1
			If StringRegExp($Stripped_ScriptData, "(?i)(?s)\" & $ConstArray[$j] & "", 0) Then
				$count += 1
				$AddInclude = 1
				ExitLoop
			EndIf
		Next
		If $AddInclude Then $Lines2Add &= "#include <" & $includes[$i] & ">" & @CRLF
		;
	Next
	FileRecycle($ScriptFile_In)
	; sleep 500 ms to ensure SciTE detects the file was changed.
	Sleep(500)
	Local $H_Outf = FileOpen($ScriptFile_In, 2)
	If $count Then
		FileWriteLine($H_Outf, "; *** Start added by AutoIt3Wrapper ***")
		FileWrite($H_Outf, $Lines2Add)
		FileWriteLine($H_Outf, "; *** End added by AutoIt3Wrapper ***")
	EndIf
	; update directive to n to avoid running it each time
	$ScriptData = StringRegExpReplace($ScriptData, '(?i)' & @CRLF & '(\h?)#AutoIt3Wrapper_Add_Constants(\h*?)=(.*?)' & @CRLF, @CRLF & '#AutoIt3Wrapper_Add_Constants=n' & @CRLF)
	; strip extra leading and trailing CRLF's and write back to file
	FileWrite($H_Outf, StringMid($ScriptData, 3))
	FileClose($H_Outf)
	ConsoleWrite(" " & $count & " include(s) were added" & @CRLF)
EndFunc   ;==>Add_Constants
;
; Check for the availablility of New installers for SciTE4AutoIT3
Func CheckForUpdates()
	$rc = InetGet('http://www.autoitscript.com/autoit3/scite/download/scite4autoit3version.ini', $SciTE_Dir & "\scite4autoit3versionWeb.ini", 1, 1)
	For $x = 1 To 15
		If Not @InetGetActive Then ExitLoop
		Sleep(200)
	Next
	If @InetGetActive Then
		InetGet("abort")
		Return 0
	EndIf
	If $rc Then
		Local $SciTE4AutoIt3WebDate = IniRead($SciTE_Dir & "\scite4autoit3versionWeb.ini", 'SciTE4AutoIt3', 'Date', '')
		Local $SciTE4Au3UpdWebDate = IniRead($SciTE_Dir & "\scite4autoit3versionWeb.ini", 'SciTE4Au3Upd', 'Date', '')
		Local $SciTE4AutoIt3RegDate = RegRead("HKLM\Software\Microsoft\Windows\Currentversion\Uninstall\SciTE4AutoIt3", 'DisplayVersion')
		Local $SciTE4AutoIt3Date = IniRead($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'Date', '')
		Local $SciTE4Au3UpdDate = IniRead($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4Au3Upd', 'Date', '')
		; If the INI date is blank then use the registry Date
		If $SciTE4AutoIt3Date = "" Then
			; If registry date is empty then assume the installer is never used and thus Return.
			If $SciTE4AutoIt3RegDate = "" Then Return
			$SciTE4AutoIt3Date = $SciTE4AutoIt3RegDate
			IniWrite($SciTE_Dir & "\SciTEVersion.ini", 'SciTE4AutoIt3', 'Date', $SciTE4AutoIt3Date)
		EndIf
		; Check for updated SciTE4AutoIt3 Installer
		If _Compare_Date_GT($SciTE4AutoIt3WebDate, $SciTE4AutoIt3Date) > 0 Then
			$msg = "->***********************************************************************************************" & @CRLF & _
					"->There is a new SciTE4AutoIt3 version available dated " & $SciTE4AutoIt3WebDate & _
					", your version is dated " & $SciTE4AutoIt3Date & @CRLF & _
					"->Visit http://www.autoitscript.com/autoit3/scite to download latest version." & @CRLF & _
					"->***********************************************************************************************" & @CRLF
			ConsoleWrite($msg)
		Else
			; Check for Patch updates
			If $SciTE4Au3UpdWebDate <> "" And _Compare_Date_GT($SciTE4Au3UpdWebDate, $SciTE4Au3UpdDate) > 0 Then
				$msg = "->***********************************************************************************************" & @CRLF & _
						"->There is a SciTE4Au3Upd installer available dated: " & $SciTE4Au3UpdWebDate & @CRLF & _
						"->Visit http://www.autoitscript.com/autoit3/scite to download latest version." & @CRLF & _
						"->***********************************************************************************************" & @CRLF
				ConsoleWrite($msg)
			EndIf
		EndIf
	EndIf
	Return 1
EndFunc   ;==>CheckForUpdates
Func Convert_RES_GenDirective($section, $kword, $directive, $default, $translate, ByRef $directives)
	Local $tarray = StringSplit($translate, ";")
	Local $value = IniRead($ScriptFile_In & ".ini", $section, $kword, $default)
	Local $varray
	For $x = 1 To $tarray[0]
		$varray = StringSplit($tarray[$x], "=")
		If $varray[0] > 1 And $varray[1] = $value Then $value = $varray[2]
	Next
	If $value = "" Or $value = $default Then Return
	$directives &= $directive & "=" & IniRead($ScriptFile_In & ".ini", $section, $kword, $default) & @CRLF
EndFunc   ;==>Convert_RES_GenDirective
Func Convert_RES_INI_to_Directives()
	Local $directives = "#Region converted Directives from " & $ScriptFile_In & ".ini" & @CRLF
	Convert_RES_GenDirective("Autoit", "aut2exe", "#AutoIt3Wrapper_aut2exe", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "icon", "#AutoIt3Wrapper_icon", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "outfile", "#AutoIt3Wrapper_outfile", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "Compression", "#AutoIt3Wrapper_Compression", "2", "", $directives)
	Convert_RES_GenDirective("Autoit", "PassPhrase", "#AutoIt3Wrapper_PassPhrase", "", "", $directives)
	Convert_RES_GenDirective("Autoit", "UseUpx", "#AutoIt3Wrapper_UseUpx", "y", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Autoit", "UseAnsi", "#AutoIt3Wrapper_UseAnsi", "n", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Autoit", "UseX64", "#AutoIt3Wrapper_UseX64", "n", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Autoit", "Allow_Decompile", "#AutoIt3Wrapper_Allow_Decompile", "y", "1=y;0=n;4=n", $directives)
	;
	Convert_RES_GenDirective("Res", "Comment", "#AutoIt3Wrapper_Res_Comment", "", "", $directives)
	Convert_RES_GenDirective("Res", "Description", "#AutoIt3Wrapper_Res_Description", "", "", $directives)
	Convert_RES_GenDirective("Res", "Fileversion", "#AutoIt3Wrapper_Res_Fileversion", "", "", $directives)
	Convert_RES_GenDirective("Res", "Fileversion_AutoIncrement", "#AutoIt3Wrapper_Res_Fileversion_AutoIncrement", "", "", $directives)
	Convert_RES_GenDirective("Res", "LegalCopyright", "#AutoIt3Wrapper_Res_LegalCopyright", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field1Name", "#AutoIt3Wrapper_Res_Field1Name", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field2Name", "#AutoIt3Wrapper_Res_Field2Name", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field1Value", "#AutoIt3Wrapper_Res_Field1Value", "", "", $directives)
	Convert_RES_GenDirective("Res", "Field2Value", "#AutoIt3Wrapper_Res_Field2Value", "", "", $directives)
	;
	Convert_RES_GenDirective("Other", "Run_AU3Check", "#AutoIt3Wrapper_Run_AU3Check", "y", "1=y;0=n;4=n", $directives)
	Convert_RES_GenDirective("Other", "AU3Check_Stop_OnWarning", "#AutoIt3Wrapper_AU3Check_Stop_OnWarning", "", "", $directives)
	Convert_RES_GenDirective("Other", "AU3Check_Parameter", "#AutoIt3Wrapper_AU3Check_Parameters", "", "", $directives)
	Convert_RES_GenDirective("Other", "Run_Before", "#AutoIt3Wrapper_Run_Before", "", "", $directives)
	Convert_RES_GenDirective("Other", "Run_After", "#AutoIt3Wrapper_Run_After", "", "", $directives)
	Convert_RES_GenDirective("Other", "Run_cvsWrapper", "#AutoIt3Wrapper_Run_cvsWrapper", "", "", $directives)
	Convert_RES_GenDirective("Other", "cvsWrapper_Parameter", "#AutoIt3Wrapper_cvsWrapper_Parameters", "", "", $directives)
	;
	$directives &= "#EndRegion converted Directives from " & $ScriptFile_In & ".ini" & @CRLF & ";" & @CRLF
	$directives &= FileRead($ScriptFile_In)
	Local $Fh = FileOpen($ScriptFile_In, 2)
	FileWrite($Fh, $directives)
	FileClose($Fh)
	FileRecycle($ScriptFile_In & ".ini")
	ConsoleWrite('->================================================================================================================' & @CRLF)
	ConsoleWrite('->File:' & $ScriptFile_In & ".ini" & @CRLF)
	ConsoleWrite('-> converted to #Directives at the top of the script and the file put into the recycleBin.' & @CRLF)
	ConsoleWrite('->================================================================================================================' & @CRLF)
EndFunc   ;==>Convert_RES_INI_to_Directives
Func Convert_Variables($I_String, $text = 0)
	$I_String = StringReplace($I_String, "%in%", $ScriptFile_In)
	$I_String = StringReplace($I_String, "%out%", $ScriptFile_Out)
	$I_String = StringReplace($I_String, "%icon%", $INP_Icon)
	$I_String = StringReplace($I_String, "%fileversion%", $INP_Fileversion)
	$I_String = StringReplace($I_String, "%fileversionnew%", $INP_Fileversion_New)
	Local $ScriptName = StringTrimLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1))
	Local $ScriptDir = StringLeft($ScriptFile_In, StringInStr($ScriptFile_In, "\", 0, -1) - 1)
	$I_String = StringReplace($I_String, "%scriptfile%", StringReplace($ScriptName, $ScriptFile_In_Ext, ''))
	$I_String = StringReplace($I_String, "%scriptdir%", $ScriptDir)
	$I_String = StringReplace($I_String, "%scitedir%", $SciTE_Dir)
	$I_String = StringReplace($I_String, "%autoitdir%", $INP_AutoitDir)
	$I_String = StringReplace($I_String, "%AutoItVer%", $AUT2EXE_PGM_VER)
	$I_String = StringReplace($I_String, "%Date%", _NowDate())
	$I_String = StringReplace($I_String, "%LongDate%", _DateTimeFormat(_NowCalcDate(), 1))
	$I_String = StringReplace($I_String, "%Time%", _NowTime())
	; These should only be done on text Items, strings containing a File/Path will give problems
	If $text Then
		$I_String = StringReplace($I_String, "\n", @CRLF)
	EndIf
	Return $I_String
EndFunc   ;==>Convert_Variables
;
;
;
Func Language_Code($code)
	Local $CountryTable = _
			"Afrikaans,1078|" & _
			"Albanian,1052|" & _
			"Arabic (Algeria),5121|" & _
			"Arabic (Bahrain),15361|" & _
			"Arabic (Egypt),3073|" & _
			"Arabic (Iraq),2049|" & _
			"Arabic (Jordan),11265|" & _
			"Arabic (Kuwait),13313|" & _
			"Arabic (Lebanon),12289|" & _
			"Arabic (Libya),4097|" & _
			"Arabic (Morocco),6145|" & _
			"Arabic (Oman),8193|" & _
			"Arabic (Qatar),16385|" & _
			"Arabic (Saudi Arabia),1025|" & _
			"Arabic (Syria),10241|" & _
			"Arabic (Tunisia),7169|" & _
			"Arabic (U.A.E.),14337|" & _
			"Arabic (Yemen),9217|" & _
			"Basque,1069|" & _
			"Belarusian,1059|" & _
			"Bulgarian,1026|" & _
			"Catalan,1027|" & _
			"Chinese (Hong Kong SAR),3076|" & _
			"Chinese (PRC),2052|" & _
			"Chinese (Singapore),4100|" & _
			"Chinese (Taiwan),1028|" & _
			"Croatian,1050|" & _
			"Czech,1029|" & _
			"Danish,1030|" & _
			"Dutch,1043|" & _
			"Dutch (Belgium),2067|"
	$CountryTable &= _
			"English (Australia),3081|" & _
			"English (Belize),10249|" & _
			"English (Canada),4105|" & _
			"English (Ireland),6153|" & _
			"English (Jamaica),8201|" & _
			"English (New Zealand),5129|" & _
			"English (South Africa),7177|" & _
			"English (Trinidad),11273|" & _
			"English (United Kingdom),2057|" & _
			"English (United States),1033|" & _
			"Estonian,1061|" & _
			"Faeroese,1080|" & _
			"Farsi,1065|" & _
			"Finnish,1035|" & _
			"French (Standard),1036|" & _
			"French (Belgium),2060|" & _
			"French (Canada),3084|" & _
			"French (Luxembourg),5132|" & _
			"French (Switzerland),4108|" & _
			"Gaelic (Scotland),1084|" & _
			"German (Standard),1031|" & _
			"German (Austrian),3079|" & _
			"German (Liechtenstein),5127|" & _
			"German (Luxembourg),4103|" & _
			"German (Switzerland),2055|" & _
			"Greek,1032|" & _
			"Hebrew,1037|" & _
			"Hindi,1081|" & _
			"Hungarian,1038|"
	$CountryTable &= _
			"Icelandic,1039|" & _
			"Indonesian,1057|" & _
			"Italian (Standard),1040|" & _
			"Italian (Switzerland),2064|" & _
			"Japanese,1041|" & _
			"Korean,1042|" & _
			"Latvian,1062|" & _
			"Lithuanian,1063|" & _
			"Macedonian (FYROM),1071|" & _
			"Malay (Malaysia),1086|" & _
			"Maltese,1082|" & _
			"Norwegian (Bokmål),1044|" & _
			"Polish,1045|" & _
			"Portuguese (Brazil),1046|" & _
			"Portuguese (Portugal),2070|" & _
			"Raeto (Romance),1047|" & _
			"Romanian,1048|" & _
			"Romanian (Moldova),2072|" & _
			"Russian,1049|" & _
			"Russian (Moldova),2073|" & _
			"Serbian (Cyrillic),3098|" & _
			"Setsuana,1074|" & _
			"Slovak,1051|" & _
			"Slovenian,1060|" & _
			"Sorbian,1070|"
	$CountryTable &= _
			"Spanish (Argentina),11274|" & _
			"Spanish (Bolivia),16394|" & _
			"Spanish (Chile),13322|" & _
			"Spanish (Columbia),9226|" & _
			"Spanish (Costa Rica),5130|" & _
			"Spanish (Dominican Republic),7178|" & _
			"Spanish (Ecuador),12298|" & _
			"Spanish (El Salvador),17418|" & _
			"Spanish (Guatemala),4106|" & _
			"Spanish (Honduras),18442|" & _
			"Spanish (Mexico),2058|" & _
			"Spanish (Nicaragua),19466|" & _
			"Spanish (Panama),6154|" & _
			"Spanish (Paraguay),15370|" & _
			"Spanish (Peru),10250|" & _
			"Spanish (Puerto Rico),20490|" & _
			"Spanish (Spain),1034|" & _
			"Spanish (Uruguay),14346|" & _
			"Spanish (Venezuela),8202|" & _
			"Sutu,1072|" & _
			"Swedish,1053|" & _
			"Swedish (Finland),2077|" & _
			"Thai,1054|" & _
			"Turkish,1055|" & _
			"Tsonga,1073|" & _
			"Ukranian,1058|" & _
			"Urdu (Pakistan),1056|" & _
			"Vietnamese,1066|" & _
			"Xhosa,1076|" & _
			"Yiddish,1085|" & _
			"Zulu,1077|"
	Local $Found = StringInStr($CountryTable, "," & $code & "|")
	If $Found Then
		$CountryTable = StringLeft($CountryTable, $Found - 1)
		Return StringMid($CountryTable, StringInStr($CountryTable, "|", Default, -1) + 1)
	Else
		Return "Unknown Country code specified"
	EndIf
EndFunc   ;==>Language_Code
Func OnAutoItExit()
	; only show this line for main script run not the Watcher
	If Not StringInStr($CMDLINERAW, "/watcher") Then Write_RC_Console_Msg("AutoIt3Wrapper Finished", "", "+")
EndFunc   ;==>OnAutoItExit
; Retrieve the compiler settings from the scriptfile when available
Func Retrieve_PreProcessor_Info()
	Local $I_Rec
	Local $In_File
	Local $hTest_UTF = FileOpen($ScriptFile_In, 16)
	Local $Test_UTF = FileRead($hTest_UTF, 4)
	Local $i_Rec_Param, $i_Rec_Value, $Temp_Val, $Fh
	FileClose($hTest_UTF)
;~ 00 00 FE FF UTF-32, big-endian
;~ FF FE 00 00 UTF-32, little-endian
;~ FE FF UTF-16, big-endian
;~ FF FE UTF-16, little-endian
;~ EF BB BF UTF-8
	If $Test_UTF = "0x0000FFFE" Or $Test_UTF = "0xFFFE0000" Then
		ConsoleWrite("! ***************************************************************************************************" & @CRLF)
		ConsoleWrite("! * Input file is UTF32 encoded, Au3Check/Tidy/Obfuscator do no support UNICODE and will be skipped.*" & @CRLF)
		ConsoleWrite("! ***************************************************************************************************" & @CRLF)
		$InputFileIsUTF16 = 1
	Else
		$hTest_UTF = FileOpen($ScriptFile_In, 16)
		$Test_UTF = FileRead($hTest_UTF, 2)
		FileClose($hTest_UTF)
		If $Test_UTF = "0xFFFE" Or $Test_UTF = "0xFEFF" Then
			ConsoleWrite("! ***************************************************************************************************" & @CRLF)
			ConsoleWrite("! * Input file is UTF16 encoded, Au3Check/Tidy/Obfuscator do no support UNICODE and will be skipped.*" & @CRLF)
			ConsoleWrite("! ***************************************************************************************************" & @CRLF)
			$InputFileIsUTF16 = 1
		Else
			$hTest_UTF = FileOpen($ScriptFile_In, 16)
			$Test_UTF = FileRead($hTest_UTF, 3)
			FileClose($hTest_UTF)
			If $Test_UTF = "0xEFBBBF" Then
				ConsoleWrite("! ***************************************************************************************************" & @CRLF)
				ConsoleWrite("! * Input file is UTF8 encoded with BOM, Au3Check does not support UNICODE and will be skipped.     *" & @CRLF)
				ConsoleWrite("! ***************************************************************************************************" & @CRLF)
				$InputFileIsUTF16 = 1
			EndIf
		EndIf
	EndIf
	If _FileReadToArray($ScriptFile_In, $In_File) = 0 Then Return
	Local $Found_Old_Compiler = 0
	For $rcount = 1 To $In_File[0]
		$I_Rec = $In_File[$rcount]
		$I_Rec = StringStripWS($I_Rec, 1)
		If StringLeft($I_Rec, 16) <> "#AutoIt3Wrapper_" And StringLeft($I_Rec, 9) <> "#Compiler" And StringLeft($I_Rec, 5) <> "#Run_" Then ContinueLoop
		If StringInStr($I_Rec, ";") Then
			$I_Rec = StringLeft($I_Rec, StringInStr($I_Rec, ";") - 1)
		EndIf
		$I_Rec = StringStripWS($I_Rec, 3)
		$i_Rec_Param = StringLeft($I_Rec, StringInStr($I_Rec, "=") - 1)
		$i_Rec_Param = StringStripWS($i_Rec_Param, 3)
		$i_Rec_Value = StringTrimLeft($I_Rec, StringInStr($I_Rec, "="))
		$i_Rec_Value = StringStripWS($i_Rec_Value, 3)
		; we added AutoIt3Wrapper_ for clearity to the compiler directives.
		If Not $Found_Old_Compiler And StringLeft($I_Rec, 10) = "#Compiler_" Then $Found_Old_Compiler = 1
		If StringLeft($I_Rec, 15) = "#Run_Debug_Mode" Then $Found_Old_Compiler = 2
		$i_Rec_Param = StringReplace($i_Rec_Param, "#Compiler_", "#AutoIt3Wrapper_")
		Select
			; ================ AutoIt3/Aut2EXE  =========================================================================
			Case $i_Rec_Param = "#AutoIt3Wrapper_Prompt"
				; Obsolete..... Only override the command line when an actual value is given
			Case $i_Rec_Param = "#AutoIt3Wrapper_OutFile"
				$ScriptFile_Out = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_OutFile_Type"
				$ScriptFile_Out_Type = $i_Rec_Value
				If $ScriptFile_Out_Type <> "A3X" And $ScriptFile_Out_Type <> "EXE" Then
					$ScriptFile_Out_Type = ""
					ConsoleWrite("- Skipping #Compiler_OutFile_Type directive. Invalid type:" & $i_Rec_Value & ". Can only be A3X or EXE" & @CRLF)
				Else
					; Only use the "#AutoIt3Wrapper_OutFile_Type" when "#AutoIt3Wrapper_OutFile" isn't given
					If $ScriptFile_Out = "" Then
						$ScriptFile_Out = StringTrimRight($ScriptFile_In, StringLen($ScriptFile_In_Ext)) & '.' & $ScriptFile_Out_Type
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Icon"
				$INP_Icon = StringReplace($i_Rec_Value, '"', '')
				$DebugIcon = $DebugIcon & "Comp directive icon: " & $INP_Icon & @CRLF
			Case $i_Rec_Param = "#AutoIt3Wrapper_Compression"
				$INP_Compression = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_PassPhrase"
;~ 				$INP_PassPhrase = $i_Rec_Value
;~ 				$INP_PassPhrase2 = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Version"
				; Only use the compiler directive when the /prod or /beta is missing from the commandline
				If $INP_AutoIT3_Version = "" Then
					If $i_Rec_Value = "b" Or $i_Rec_Value = "beta" Then
						$INP_AutoIT3_Version = "beta"
						$INP_AutoitDir = RegRead($RegistryLM, 'BetaInstallDir')
						$ObfuscatorCmdLine &= "/Beta"
					Else
						$INP_AutoIT3_Version = "prod"
						$INP_AutoitDir = RegRead($RegistryLM, 'InstallDir')
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_AUTOIT3"
				$AutoIT3_PGM = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_AU3Check_Dat"
				; Obsolete..... Only override the command line when an actual value is given
			Case $i_Rec_Param = "#AutoIt3Wrapper_AUT2EXE"
				$AUT2EXE_PGM = StringReplace($i_Rec_Value, '"', '')
			Case $i_Rec_Param = "#AutoIt3Wrapper_UseUpx"
				$INP_UseUpx = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_UseAnsi"
				$INP_UseAnsi = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_UseX64"
				$INP_UseX64 = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Allow_Decompile"
				; Obsolete.....  $INP_Allow_Decompile = $i_Rec_Value
			Case $i_Rec_Param = "#Run_Debug_Mode" Or $i_Rec_Param = "#AutoIt3Wrapper_Run_Debug_Mode"
				If $i_Rec_Value = "y" Or $i_Rec_Value = 1 Then $INP_Run_Debug_Mode = 1
				; ================ Resources  =========================================================================
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Language"
				$INP_Res_Language = Number($i_Rec_Value)
				If $INP_Res_Language = 0 Then $INP_Res_Language = 2057
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Comment"
				$INP_Comment = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Description"
				$INP_Description = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Fileversion"
				$INP_Fileversion = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_FileVersion_AutoIncrement"
				$INP_Fileversion_AutoIncrement = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_LegalCopyright"
				$INP_LegalCopyright = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
				; limited number of free format resource info fields
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Icon_Add"
				If $i_Rec_Value <> "" Then
					$INP_Icons_cnt += 1
					ReDim $INP_Icons[$INP_Icons_cnt + 1]
					$INP_Icons[$INP_Icons_cnt] = Convert_Variables(StringReplace($i_Rec_Value, '"', ''))
					If Not FileExists($INP_Icons[$INP_Icons_cnt]) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_Res_Icon_Add because the Ico file is not found:" & $INP_Icons[$INP_Icons_cnt] & @CRLF)
						$INP_Icons_cnt -= 1
					Else
						$INP_Resource = 1
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_File_Add"
				If $i_Rec_Value <> "" Then
					$INP_Files_cnt += 1
					ReDim $INP_Files[$INP_Files_cnt + 1]
					$INP_Files[$INP_Files_cnt] = Convert_Variables(StringReplace($i_Rec_Value, '"', ''))
					Local $ResFileInfo
					$ResFileInfo = StringSplit($INP_Files[$INP_Files_cnt], ",")
					If Not FileExists($ResFileInfo[1]) Then
						ConsoleWrite("- Skipping #AutoIt3Wrapper_Res_File_Add because the file is not found:" & $INP_Files[$INP_Files_cnt] & @CRLF)
						$INP_Files_cnt -= 1
					Else
						$INP_Resource = 1
					EndIf
				EndIf
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_SaveSource"
				$INP_Res_SaveSource = $i_Rec_Value
				$INP_Resource = 1
				; ================ Other =========================================================================
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field"
				$Temp_Val = StringSplit($i_Rec_Value, "|")
				If $INP_RES_FieldCount > 14 Then
					ConsoleWrite("- Skipping #Compiler_Res_Field directive. You can only have 15 field max:" & $i_Rec_Value & @CRLF)
				ElseIf $Temp_Val[0] <> 2 Then
					ConsoleWrite("- Skipping #Compiler_Res_Field directive. Doesn't have a | in it:" & $i_Rec_Value & @CRLF)
				Else
					$INP_RES_FieldCount = $INP_RES_FieldCount + 1
					$INP_FieldName[$INP_RES_FieldCount] = $Temp_Val[1]
					$INP_FieldValue[$INP_RES_FieldCount] = $Temp_Val[2]
				EndIf
				$INP_Resource_Version = 1
				$INP_Resource = 1
				; Old format for Resource fields
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field1Value"
				$INP_FieldValue1 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field1Name"
				$INP_FieldName1 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field2Value"
				$INP_FieldValue2 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_Res_Field2Name"
				$INP_FieldName2 = $i_Rec_Value
				$INP_Resource_Version = 1
				$INP_Resource = 1
			Case $i_Rec_Param = "#AutoIt3Wrapper_res_requestedExecutionLevel"
				;None, asInvoker, highestAvailable or requireAdministrator   (default=None)"
				Switch $i_Rec_Value
					Case "", "None"
						$INP_RES_requestedExecutionLevel = ""
					Case "asInvoker", "highestAvailable", "requireAdministrator"
						$INP_RES_requestedExecutionLevel = $i_Rec_Value
						$INP_Resource = 1
					Case Else
						$INP_RES_requestedExecutionLevel = ""
						ConsoleWrite("- Skipping #AutoIt3Wrapper_res_requestedExecutionLevel directive. Invalid value:" & $i_Rec_Value & @CRLF)
				EndSwitch
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_AU3Check"
				$INP_Run_AU3Check = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_AU3Check_Parameters"
				$INP_AU3Check_Parameters = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_AU3Check_Stop_OnWarning"
				$INP_AU3Check_Stop_OnWarning = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_Tidy"
				$INP_Run_Tidy = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_Obfuscator"
				$INP_Run_Obfuscator = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Tidy_Stop_OnError"
				$INP_Tidy_Stop_OnError = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_Before"
				$INP_Run_Before = $INP_Run_Before & $i_Rec_Value & "|"
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_After"
				$INP_Run_After = $INP_Run_After & $i_Rec_Value & "|"
			Case $i_Rec_Param = "#AutoIt3Wrapper_Run_cvsWrapper"
				$INP_Run_cvsWrapper = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_cvsWrapper_Parameters"
				$INP_cvsWrapper_Parameters = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_PlugIn_Funcs"
				$INP_Plugin = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Change2CUI"
				$INP_Change2CUI = $i_Rec_Value
			Case $i_Rec_Param = "#AutoIt3Wrapper_Add_Constants"
				$INP_Add_Constants = $i_Rec_Value
			Case Else
				MsgBox(262144 + 32, 'Invalid Compiler directive', 'Keyword:' & $i_Rec_Param & @LF & 'Value:' & $i_Rec_Value)
		EndSelect
	Next
	If $Found_Old_Compiler Then
		If MsgBox(262144 + 4096 + 4, "AutoIt3Wrappper", "Found OLD #Compiler Directives." & @LF & _
				"Do you want to updated your script to #AutoIt3Wrapper Directives?", 10) = 6 Then
			; Ask SciTE for the current buffer/filename
;~          ; - removed because it left the Find/Replace window open after the replace was finished.
;~ 			$CurSciTEFile = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askfilename:")
;~ 			$CurSciTEFile = StringReplace($CurSciTEFile, "filename:", "")
;~ 			$CurSciTEFile = StringReplace($CurSciTEFile, "\\", "\")
			; when its the correct "active" filename then do a replace via SciTE Director interface and jump back to the correct line
;~ 			If $CurSciTEFile = $ScriptFile_In Then
;~ 				$CurSciTELine = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:SelectionStartLine")
;~ 				$FindVer = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "find:" & $INP_Fileversion)
;~ 				$CurSelection = SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, "askproperty:CurrentSelection")
;~ 				$sCmd = "replaceall:#Compiler_\000#AutoIt3Wrapper_"
;~ 				SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
;~ 				;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @LF & '$sCmd' & @LF & @LF & 'Return:' & @LF & $sCmd & @LF & @LF & '@Error:' & @LF & @error) ;### Debug MSGBOX
;~ 				If $Found_Old_Compiler = 2 Then
;~ 					$sCmd = "replaceall:#Run_Debug_Mode\000#AutoIt3Wrapper_Run_Debug_Mode"
;~ 					SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
;~ 				EndIf
;~ 				$sCmd = "goto:" & $CurSciTELine
;~ 				SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
;~ 				ConsoleWrite('>Updated the directives from "#Compiler_" to "#AutoIt3Wrapper_" ..' & @CRLF)
;~ 			Else
			Local $ScriptSource = FileRead($ScriptFile_In)
			$ScriptSource = StringReplace($ScriptSource, "#Compiler_", "#AutoIt3Wrapper_")
			$ScriptSource = StringReplace($ScriptSource, "#Run_Debug_Mode", "#AutoIt3Wrapper_Run_Debug_Mode")
			$Fh = FileOpen($ScriptFile_In, 2)
			FileWrite($Fh, $ScriptSource)
			FileClose($Fh)
			ConsoleWrite('>Updated the directives from "#Compiler_" to "#AutoIt3Wrapper_" ...' & @CRLF)
;~ 			EndIf
		EndIf
	EndIf
EndFunc   ;==>Retrieve_PreProcessor_Info
;
Func RunAutoItDebug($sFileToDebug, ByRef $sDebugFile)
	; Klaatu on AutoIt3 forum
	; DebugIt.au3  http://www.autoitscript.com/forum/index.php?s=&showtopic=35218&view=findpost&p=258014
	;
	; Version 1.0 - initial release
	;
	; Run an AutoIt script, outputing each line executed to a window.
	;
	; Syntax 1:
	;    AutoIt3 DebugIt.au3 yourscript.au3 params
	; Syntax 2:
	;    DebugIt.exe yourscript.au3 params
	;
	; Run DebugIt - choose a file - the script will then write out a file called
	; filename_DebugIt.au3 This file should be identical to your script except that
	; before every line of code there is an instruction to write out the original
	; script line to a control in a window we create.
	; If the script crashes out - or whatever - you just look at the the last line
	; written out to indicate where the script crashed.
	;
	; You can prevent any particular section of code (such as an AdLib function)
	; from having debug code added by placing a line with just ";debug" before and
	; after the section.
	;
	; NOTE: Requires AutoIt 3.2+!!!
	;
	Local $fhFileToDebug, $fhDebugFile
	Local $iLineNumber, $sCurrentLine, $sComment, $sModifiedLine, $bDebugging
	Local $sRandom = '', $sIndent, $sTitle, $x
	Local $sDrive, $sDir, $sFName, $iSavedLine

	_PathSplit($sFileToDebug, $sDrive, $sDir, $sFName, $x)
	; The title of our debug window will be the filename portion only, but with "_DebugIt" added.
	$sTitle = $sFName & '_DebugIt'
	; Our temporary script will use this title for its name. We also make sure to create the
	; temporary script in the same folder as the original, in case it relies on other things
	; being found relative to where it is.
	$sDebugFile = _PathMake($sDrive, $sDir, $sTitle, $x)
	; We use a Random 8 character string for 2 purposes:
	;   1) to almost guarantee that the variables we add to the script don't conflict
	;      with the script's own variables, and
	;   2) to make sure we're communicating with one and only one debug window, as we
	;      look for this random string to be text in the window we want to communicate with.
	While StringLen($sRandom) < 8
		$sRandom &= Chr(Round(Random(97, 122), 0))
	WEnd
	$fhDebugFile = FileOpen($sDebugFile, 2)
	If @error Then
		MsgBox(0, @ScriptName, 'File ' & $sDebugFile & ' could not be opened')
		Exit (3)
	EndIf
	;
	FileWriteLine($fhDebugFile, "Global $__err" & $sRandom & "[2] = [0, 0]")
	$fhFileToDebug = FileOpen($sFileToDebug, 0)
	$iLineNumber = 1
	$bDebugging = True
	While True
		$iSavedLine = $iLineNumber
		$sCurrentLine = FileReadLine($fhFileToDebug)
		If @error = -1 Then ExitLoop
		; Handle continuation lines. This does need to be more sophisticated to handle
		; comments that follow line continuations; right now it's pretty basic.
		While StringRight($sCurrentLine, 2) = ' _'
			$sCurrentLine = StringTrimRight($sCurrentLine, 1)
			$iLineNumber += 1
			$sCurrentLine &= StringStripWS(FileReadLine($fhFileToDebug, $iLineNumber), 1)
			If @error = -1 Then ExitLoop
		WEnd
		; look for lines that tell us whether to stop or start adding debugging to the script
		; there's no special code to watch for #cs/#ce blocks, as it actually doesn't matter;
		; debug code will be added to these blocks, but so what?
		If StringStripWS($sCurrentLine, 8) = ";debug" Then
			$bDebugging = Not $bDebugging
			$iLineNumber += 1
			FileWriteLine($fhDebugFile, $sCurrentLine)
			ContinueLoop
		EndIf
		;
		If $bDebugging Then
			; Turn all single quotes into double quotes so we can use single quotes to delimit the
			; line when adding it to the debugging script.
			$sModifiedLine = StringReplace($sCurrentLine, "'", '"')
			$sComment = StringStripWS(StringLeft($sModifiedLine, StringInStr($sModifiedLine, ";", -1)), 3)
			If Not ($sComment = ";") And Not (StringStripWS($sCurrentLine, 3) = "") Then
				; Proper indenting is not really needed, but it makes the temporary script
				; look a hell of a lot better if someone needs to look at it for some reason.
				$sIndent = ''
				While StringIsSpace(StringLeft($sCurrentLine, StringLen($sIndent) + 1))
					$sIndent = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
				WEnd
				; First we save the values of @Error and @Extended, then add our command that
				; updates the Edit control on our form with the script's current line, then we
				; restore @Error and @Extended to what they were. This guarantees that the
				; original script's code that relies on these values will continue to execute
				; as intended.
				FileWriteLine($fhDebugFile, StringFormat("%sDim $__err%s[2] = [@Error, @Extended]", $sIndent, $sRandom))
				; FileWriteLine($fhDebugFile, StringFormat("%sControlSetText('%s', '%s', 'Edit1', ControlGetText('%s', '%s', 'Edit1') & @CRLF & '%04u: %s')", $sIndent, $sTitle, $sRandom, $sTitle, $sRandom, $iLineNumber, $sModifiedLine))
				;FileWriteLine($fhDebugFile, StringFormat("%sControlCommand('%s', '%s', 'Edit1', 'EditPaste', '%04u: %s' & @CRLF)", $sIndent, $sTitle, $sRandom, $iSavedLine, $sModifiedLine))
				FileWriteLine($fhDebugFile, StringFormat("%sConsoleWrite('%04u: ' & $__err%s[0] & '-' & $__err%s[1] & ': %s' & @CRLF)", $sIndent, $iSavedLine, $sRandom, $sRandom, $sModifiedLine))
				FileWriteLine($fhDebugFile, StringFormat("%sSetError($__err%s[0], $__err%s[1])", $sIndent, $sRandom, $sRandom))
			EndIf
		EndIf
		FileWriteLine($fhDebugFile, $sCurrentLine)
		$iLineNumber += 1
	WEnd
	FileWriteLine($fhDebugFile, $sCurrentLine)
	FileClose($fhFileToDebug)
	FileClose($fhDebugFile)
EndFunc   ;==>RunAutoItDebug
; Validate/Translate/Set Input field value
Func SetDefaults(ByRef $fieldval, $default, $translate = "", $valid = "", $Number = 0, $Case = 0)
;~ 	ConsoleWrite('@@ ######## start Setdefaults : $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Local $tarray, $varray, $IsValid
	If $fieldval = "" Then
		$fieldval = $default
	ElseIf $translate <> "" Then
		$tarray = StringSplit($translate, ";")
		For $x = 1 To $tarray[0]
			$varray = StringSplit($tarray[$x], "=")
			If $varray[0] > 1 And $varray[1] = $fieldval Then $fieldval = $varray[2]
		Next
	EndIf
;~ 	ConsoleWrite('@@ after translate : $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If $valid <> "" Then
		$IsValid = False
		$tarray = StringSplit($valid, ";")
		For $x = 1 To $tarray[0]
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tarray[$x] = ' & $tarray[$x] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			If (StringLower($tarray[$x]) == StringLower($fieldval) And $Case = 0) Or ($tarray[$x] == $fieldval And $Case = 1) Then
				$IsValid = True
;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IsValid = ' & $IsValid & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				ExitLoop
			EndIf
		Next
		If $IsValid = False Then
			$fieldval = $default
		EndIf
	EndIf
;~ 	ConsoleWrite('@@ After validate: $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If $Number Then $fieldval = Number($fieldval)
;~ 	ConsoleWrite('@@ after number : $fieldval = ' & $fieldval & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
EndFunc   ;==>SetDefaults
;~ ; display warning window including warnings
;~ Func Show_Warnings($Warning_TiTle, $Warning_Text)
;~ 	GUICreate($Warning_TiTle, 700, 300)
;~ 	GUICtrlCreateLabel("Do you want to stop the " & $Option & "?", 100, 270, 180, 20)
;~ 	Local $H_Yes = GUICtrlCreateButton("Stop", 280, 263, 60, 25)
;~ 	Local $H_No = GUICtrlCreateButton("Continue anyway", 360, 263, 100, 25)
;~ 	GUISetFont(9, 400, 0, "Courier New")
;~ 	;GUISetBkColor(0xFFEFEF)
;~ 	GUICtrlCreateEdit(StringReplace($Warning_Text, @LF, @CRLF), 10, 10, 680, 250, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
;~ 	;GUICtrlCreateLabel($Warning_Text, 10, 10, 680, 250, $WS_BORDER)
;~ 	GUICtrlSetBkColor(-1, 0xFFEFEF)
;~ 	GUICtrlSetState($H_Yes, $GUI_FOCUS)
;~ 	GUISetState(@SW_SHOW)

Func Show_Warnings($Warning_TiTle, $Warning_Text)
	GUICreate($Warning_TiTle, 700, 310, -1, -1, $WS_SIZEBOX + $WS_SYSMENU + $WS_MINIMIZEBOX)
	GUICtrlCreateLabel("Do you want to stop the " & $Option & "?", 5, 257, 180, 20)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKSIZE)
	Local $H_Yes = GUICtrlCreateButton("Stop", 280, 253, 60, 25)
	GUICtrlSetResizing($H_Yes, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE + $GUI_DOCKHCENTER)
	Local $H_No = GUICtrlCreateButton("Continue anyway", 360, 253, 100, 25)
	GUICtrlSetResizing($H_No, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE + $GUI_DOCKHCENTER)
	GUISetFont(9, 400, 0, "Courier New")
	GUICtrlCreateEdit(StringReplace($Warning_Text, @LF, @CRLF), 5, 5, 690, 240, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	GUICtrlSetBkColor(-1, 0xFFEFEF)
	GUICtrlSetState($H_Yes, $GUI_FOCUS)
	GUISetState(@SW_SHOW) ; Process GUI Input
	; Process GUI Input
	;-------------------------------------------------------------------------------------------
	While 1
		$rc = GUIGetMsg()
		Sleep(10)
		If $rc = 0 Then ContinueLoop
		; Cancel clicked
		If $rc = $H_Yes Then Exit
		If $rc = $H_No Then ExitLoop
		If $rc = -3 Then Exit
	WEnd
	GUIDelete()
EndFunc   ;==>Show_Warnings
;
Func ShowStdOutErr($l_Handle, $ShowConsole = 1)
	Local $Line, $tot_out, $err1 = 0, $err2 = 0
	Do
		Sleep(10)
		$Line = StdoutRead($l_Handle)
		$err1 = @error
		$tot_out &= $Line
		If $ShowConsole Then ConsoleWrite($Line)
		$Line = StderrRead($l_Handle)
		$err2 = @error
		$tot_out &= $Line
		If $ShowConsole Then ConsoleWrite($Line)
	Until $err1 And $err2
	Return $tot_out
EndFunc   ;==>ShowStdOutErr
;
Func Valid_FileVersion($i_FileVersion)
	Local $T_Numbers = StringSplit($i_FileVersion, ".")
	If $T_Numbers[0] > 4 Then
		ConsoleWrite("- RC Invalid FileVersion :" & $i_FileVersion & ", contains more then 4 numbers.... Changed to:" & $AUT2EXE_PGM_VER & @CRLF)
		Return $AUT2EXE_PGM_VER
	EndIf
	;
	If $T_Numbers[0] < 4 Then ReDim $T_Numbers[5]
	For $x = 1 To 4
		If $T_Numbers[$x] = '' Then $T_Numbers[$x] = 0
		If Not ($T_Numbers[$x] == Number($T_Numbers[$x])) Then
			ConsoleWrite("! Invalid FileVersion value " & $x & "=" & $T_Numbers[$x] & ". It will be changed to:" & Number($T_Numbers[$x]) & @CRLF)
			$T_Numbers[$x] = Number($T_Numbers[$x])
		EndIf
	Next
	; Auto Increment when requested
	If $INP_Fileversion_AutoIncrement <> "n" Then
		$INP_Fileversion_New = $T_Numbers[1] & "." & $T_Numbers[2] & "." & $T_Numbers[3] & "." & $T_Numbers[4] + 1
	EndIf
	Return $T_Numbers[1] & "." & $T_Numbers[2] & "." & $T_Numbers[3] & "." & $T_Numbers[4]
EndFunc   ;==>Valid_FileVersion
;
; Write colored console message..
Func Write_RC_Console_Msg($text, $rc = "", $symbol = "")
	$text = @HOUR & ":" & @MIN & ":" & @SEC & " " & $text
	If $symbol <> "" Then
		If $rc == "" Then
			ConsoleWrite($symbol & ">" & $text & @CRLF)
		Else
			ConsoleWrite($symbol & ">" & $text & "rc:" & $rc & @CRLF)
		EndIf
	Else
		If $rc == "" Then
			ConsoleWrite(">" & $text & @CRLF)
		Else
			Switch $rc
				Case 0
					ConsoleWrite("+>" & $text & "rc:" & $rc & @CRLF)
				Case 1
					ConsoleWrite("->" & $text & "rc:" & $rc & @CRLF)
				Case Else
					ConsoleWrite("!>" & $text & "rc:" & $rc & @CRLF)
			EndSwitch
		EndIf
	EndIf
EndFunc   ;==>Write_RC_Console_Msg
#EndRegion Functions
#Region SciTE Functions
; Received Data from SciTE
Func MY_WM_COPYDATA($hWnd, $msg, $wParam, $lParam)
	#forceref $hWnd, $msg,  $wParam
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr', $lParam)
	Local $SciTECmdLen = DllStructGetData($COPYDATA, 2)
	Local $CmdStruct = DllStructCreate('Char[255]', DllStructGetData($COPYDATA, 3))
	$SciTECmd = StringLeft(DllStructGetData($CmdStruct, 1), $SciTECmdLen)
	;ConsoleWrite('<--' & $SciTECmd & @crlf )
EndFunc   ;==>MY_WM_COPYDATA
;
Func SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
	Local $WM_COPYDATA = 74
	Local $CmdStruct = DllStructCreate('Char[' & StringLen($sCmd) + 1 & ']')
	DllStructSetData($CmdStruct, 1, $sCmd)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr')
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, StringLen($sCmd) + 1)
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($CmdStruct))
	DllCall('User32.dll', 'None', 'SendMessage', 'HWnd', $SciTE_hwnd, _
			'Int', $WM_COPYDATA, 'HWnd', $My_Hwnd, _
			'Ptr', DllStructGetPtr($COPYDATA))
	;ConsoleWrite('-->' & $sCmd & @crlf )
EndFunc   ;==>SendSciTE_Command
;
Func SendSciTE_GetInfo($My_Hwnd, $SciTE_hwnd, $sCmd)
	$sCmd = ":" & $My_Dec_Hwnd & ":" & $sCmd
	$SciTECmd = ""
	SendSciTE_Command($My_Hwnd, $SciTE_hwnd, $sCmd)
	For $x = 1 To 10
		If $SciTECmd <> "" Then ExitLoop
		Sleep(20)
	Next
	$SciTECmd = StringTrimLeft($SciTECmd, StringLen(":" & $My_Dec_Hwnd & ":"))
	$SciTECmd = StringReplace($SciTECmd, "macro:stringinfo:", "")
	Return $SciTECmd
EndFunc   ;==>SendSciTE_GetInfo
#EndRegion SciTE Functions