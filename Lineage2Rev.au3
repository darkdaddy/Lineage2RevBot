#RequireAdmin

#pragma compile(FileDescription, Raven Bot)
#pragma compile(ProductName, Raven Bot)
#pragma compile(ProductVersion, 0.1)
#pragma compile(FileVersion, 0.1)
#pragma compile(LegalCopyright, DarkJaden)

$sBotName = "Lineage 2 Revolution Bot"
$sBotVersion = "0.1"
$sBotTitle = "AutoIt " & $sBotName & " v" & $sBotVersion

If _Singleton($sBotTitle, 1) = 0 Then
   MsgBox(0, "", "Bot is already running.")
   Exit
EndIf

#include <Bots/Util/SetLog.au3>
#include <Bots/Util/Time.au3>
#include <Bots/Util/CreateLogFile.au3>
#include <Bots/Util/_Sleep.au3>
#include <Bots/Util/Click.au3>
#include <ScreenCapture.au3>
#include <Bots/GlobalVariables.au3>
#include <Bots/Config.au3>
#include <Bots/AutoFlow.au3>
#include <Bots/ScrollQuest.au3>
#include <Bots/AdenaDungeon.au3>
#include <Bots/PvPBattle.au3>
#include <Bots/Form/MainView.au3>
#include-once

Opt("MouseCoordMode", 2)
Opt("GUICoordMode", 2)
Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "mainViewClose", $mainView)
GUIRegisterMsg($WM_COMMAND, "GUIControl")
GUIRegisterMsg($WM_SYSCOMMAND, "GUIControl")

; Initialize
DirCreate($dirLogs)
DirCreate($dirCapture)
_GDIPlus_Startup()
CreateLogFile()

loadConfig()
applyConfig()

Func findWindow()
   _log("findWindow called")
   Local $found = False
   Local $arr = StringSplit($TitleCandidates, "|")
   For $i = 0 To UBound($arr) - 1
	  $WinRect = WinGetPos($arr[$i])

	  If Not @error Then
		 $winList = WinList($arr[$i])
		 $count = $winList[0][0]
		 For $w = 0 To $count - 1
			$WinRect = WinGetPos( $winList[$w][1] )
			If $WinRect[2] * $WinRect[3] > (100 * 100) Then
			   $Title = $winList[$w][0]
			   $HWnD = $winList[$w][1]
			   $found = True
			EndIf
		 Next

		 If $found Then
			ExitLoop
		 EndIf
	  EndIf
   Next

   Return $found
EndFunc

; Just idle around
While 1
   Sleep(10)
WEnd

Func runBot()
   _log("START" )

   $loopCount = 0
   Local $iSec, $iMin, $iHour

   Local $errorCount = 0

   While $RunState
	  Local $hTimer = TimerInit()

	  $Restart = False

	  ; Config re-apply
      saveConfig()
      loadConfig()
	  applyConfig()

	  ; For Test
	  ;ClickControlPos($POS_TOPMENU_BAG)
	  ;ExitLoop

	  if $loopCount > 0 Then
		 _GUICtrlEdit_SetText($txtLog, "")
	  EndIf

	  SetLog("Start Loop : " & $loopCount + 1, $COLOR_PURPLE)

	  Local $res = AutoFlow()

	  If $res = False OR $RunState = False Then

		 If $res = False Then
			SetLog("Error occurred..", $COLOR_RED)
			$errorCount = $errorCount + 1
		 EndIf

		 If $errorCount > 3 Then
			SetLog("Too many error occurred..", $COLOR_RED)
			SaveImageToFile()
			ExitLoop
		 EndIf
	  Else
		 $errorCount = 0
		 $loopCount = $loopCount + 1

		 Local $time = _TicksToTime(Int(TimerDiff($hTimer)), $iHour, $iMin, $iSec)

		 $lastElapsed = StringFormat("%02i:%02i:%02i", $iHour, $iMin, $iSec)
	  EndIf

	  ExitLoop ; for one loop test
   WEnd

   _log("Bye" )
   btnStop()
EndFunc

_log("Bye!")

Func GUIControl($hWind, $iMsg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	#forceref $hWind, $iMsg, $wParam, $lParam

    Switch $iMsg
	  Case 273
		Switch $nID
			Case $GUI_EVENT_CLOSE
			   mainViewClose()
			Case $btnStop
			   btnStop()
			EndSwitch
		Case 274
			Switch $wParam
			   Case 0xf060
				  mainViewClose()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
 EndFunc   ;==>GUIControl

Func ControlPos($posInfo)

   Local $x = $posInfo[0] * $WinRect[2] / 100
   Local $y = $posInfo[1] * $WinRect[3] / 100
   Local $pos = [$x, $y]
   return $pos
EndFunc

Func ClickControlPos($posInfo, $clickCount = 1, $delayMsec = 300)

   ClickPos(ControlPos($posInfo), $delayMsec * $setting_delay_rate, $clickCount)

EndFunc

Func ClickBagItem($pos, $clickCount = 1, $delayMsec = 300)

   Local Const $MaxCol = 5
   Local Const $ItemLeft = ControlPos($POS_BAG_ITEM_LEFT)
   Local Const $ItemRight = ControlPos($POS_BAG_ITEM_RIGHT)

   Local Const $ItemPanelWidth = $ItemRight[0] - $ItemLeft[0]
   Local Const $ItemWidth = $ItemPanelWidth / $MaxCol

   Local $itemX = $ItemLeft[0] + (($pos - 1) * $ItemWidth) + ($ItemWidth / 2)
   Local $itemY = $ItemLeft[1] + ($ItemWidth / 2)

   Local $itemPos = [$itemX, $itemY]

   ClickPos($itemPos, $delayMsec, $clickCount)

EndFunc

Func CheckForPixel($screenInfo, $PixelTolerance = 12)
   Local $posInfo = [$screenInfo[0][0], $screenInfo[1][0]]
   Local $p = ControlPos($posInfo)
   Local Const $RegionSize = 3
   $x = $WinRect[0] + $p[0]
   $y = $WinRect[1] + $p[1]

   For $i = 0 To UBound($screenInfo, 2) - 1
	  Local $aCoord = PixelSearch($x, $y, $x+$RegionSize, $y+$RegionSize, $screenInfo[2][$i], $PixelTolerance)

	  If Not @error Then
		 _log("CheckForPixel : " & $p[0] & " x " & $p[1] & " => OK " & ($aCoord[0] - $WinRect[0]) & " x " & ($aCoord[1] - $WinRect[1]) & ", " & Hex($screenInfo[2][$i]));
		 return True
	  EndIf
   Next
   Local $iColor = PixelGetColor($x, $y)
   _log("CheckForPixel : " & $p[0] & "(" & $x & ") x " & $p[1] & "(" & $y & ") => FAIL (" & Hex($iColor) & ")");
   return False
EndFunc

Func WaitForPixel($screenInfo)
   Local Const $DefaultWaitMsec = 120000
   Local Const $DefaultCaptureDelay = 2000

   $timer = TimerInit()
   Do
	  If _Sleep($DefaultCaptureDelay) Then ExitLoop

	  If CheckForPixel($screenInfo) Then
		 return True
	  EndIf
   Until TimerDiff($timer) > $DefaultWaitMsec
   return False
EndFunc

Func WaitSkipScreen()
   return WaitForPixel($CHECK_SCREEN_SKIP)
EndFunc

Func CheckSkipScreen()
   return CheckForPixel($CHECK_SCREEN_SKIP)
EndFunc

Func CheckAlertPortalScreen()
   return CheckForPixel($CHECK_SCREEN_PORTALALERT)
EndFunc

Func CheckAlertInfoScreen()
   return CheckForPixel($CHECK_SCREEN_ALERT_INFO)
EndFunc

Func CheckAlertLowPowerScreen()
   return CheckForPixel($CHECK_SCREEN_ALERT_LOW_POWER)
EndFunc

Func CheckScrollQuestEndScreen()
   return CheckForPixel($CHECK_SCREEN_SCROLLQUEST_END)
EndFunc

Func ActionAttck($screenInfo, $maxSkill = 4)

   Local Const $CastDelay = 300
   Local $skill = 0

   While $RunState
	  If CheckForPixel($screenInfo, 10) Then
		 Return False
	  Else
		 ClickControlPos($POS_BATTLE_ATTACK_BUTTON)
		 Switch $skill
			Case 0
			   ClickControlPos($POS_BATTLE_RARE1_BUTTON)
			Case 1
			   ClickControlPos($POS_BATTLE_RARE2_BUTTON)
			Case 2
			   ClickControlPos($POS_BATTLE_SKILL1_BUTTON)
			Case 3
			   ClickControlPos($POS_BATTLE_SKILL2_BUTTON)
			Case 4
			   ClickControlPos($POS_BATTLE_SKILL3_BUTTON)
		 EndSwitch
		 $skill = $skill + 1
		 If $skill > $maxSkill Then
			$skill = 0
		 EndIf
	  EndIf
   WEnd
   Return True
EndFunc

