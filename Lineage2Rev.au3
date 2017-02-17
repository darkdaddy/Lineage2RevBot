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

   Local $found = False
   Local $arr = StringSplit($setting_win_title, "|")

   For $i = 1 To $arr[0]
	  $WinRect = WinGetPos($arr[$i])
	  If Not @error Then
		 $winList = WinList($arr[$i])
		 $count = $winList[0][0]
		 For $w = 1 To $count

			$WinRect = WinGetPos( $winList[$w][1] )
			If Not @error Then
			   If $WinRect[2] > $MinWinSize AND $WinRect[3] > $MinWinSize Then
				  $Title = $winList[$w][0]
				  $HWnD = $winList[$w][1]
				  $found = True
			   EndIf
			EndIf

			If $found Then
			   ExitLoop
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


;------------------------------------------------------------------------------
; Util Function

Func UpdateWindowRect()
   $r = WinGetPos($HWnD)
   If Not @error Then
	  If $r[2] > $MinWinSize AND $r[3] > $MinWinSize Then
		 $r[0] = $r[0] + $ThickFrameSize
		 $r[1] = $r[1] + $NoxTitleBarHeight
		 $r[2] = $r[2] + ($ThickFrameSize * 2)
		 $r[3] = $r[3] - $NoxTitleBarHeight - $ThickFrameSize
		 $winRect = $r
	  EndIf
   EndIf
EndFunc

Func ControlPos($posInfo)

   Local $xy = StringSplit($posInfo, $PosXYSplitter)

   Local $x = Number($xy[1]) * $WinRect[2] / 100
   Local $y = Number($xy[2]) * $WinRect[3] / 100

   $x = $x + $ThickFrameSize
   $y = $y + $NoxTitleBarHeight
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

   Local $infoArr = StringSplit($screenInfo, "|")
   Local $posArr = StringSplit($infoArr[1], ",")

   If UBound($infoArr) - 1 >= 3 Then
	  $PixelTolerance = Number($infoArr[3])
   EndIf

   Local Const $RegionSize = 3

   $okCount = 0
   For $p = 1 To UBound($posArr) - 1
	  Local $xy = StringSplit($posArr[$p], $PosXYSplitter)
	  Local $posInfo = [$xy[1], $xy[2]]

	  Local $pos = ControlPos($posInfo)
	  $x = $WinRect[0] + $pos[0]
	  $y = $WinRect[1] + $pos[1]

	  Local $found = False
	  Local $colorArr = StringSplit($infoArr[2], ",")
	  Local $answerColor = PixelGetColor($x, $y)

	  For $c = 1 To UBound($colorArr) - 1
		 Local $color = StringStripWS($colorArr[$c], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		 Local $aCoord = PixelSearch($x, $y, $x+$RegionSize, $y+$RegionSize, $color, $PixelTolerance)
		 If Not @error Then
			_log("CheckForPixel : [" & $p & "] " & $pos[0] & " x " & $pos[1] & " => OK " & ($aCoord[0] - $WinRect[0]) & " x " & ($aCoord[1] - $WinRect[1]) & ", " & $color & " (" & Hex($answerColor) & ")");
			$okCount = $okCount + 1
			$found = True
			ExitLoop
		 EndIf
	  Next

	  If $found = False Then
		 _log("CheckForPixel : " & $pos[0] & "(" & $x & ") x " & $pos[1] & "(" & $y & ") => FAIL (" & Hex($answerColor) & ")");
	  EndIf

   Next

   If $okCount == UBound($posArr) - 1 Then
	  Return True
   EndIf

   Return False
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

Func CloseAdvertisingScreen()
   If _Sleep(1000) Then Return
   If CheckForPixel($CHECK_SCREEN_ADVERTISING) Then
	  SetLog("Close Advertising", $COLOR_BLUE)
	  ClickControlPos($POS_ALERT_ALERT_ADVERTISING_CLOSE_BUTTON, 1, 800)
	  If _Sleep(500) Then Return
   EndIf
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

