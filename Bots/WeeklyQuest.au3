#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func DoWeeklyQuest()

   SetLog("WeeklyQuest Start", $COLOR_RED)

   Local Const $CheckDelay = 2000

   $loopCount = 1

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------

	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  SetLog("Open Quest", $COLOR_DARKGREY)
	  ClickControlPos($POS_TOPMENU_QUEST)

	  SetLog("Open Weekly Quest", $COLOR_DARKGREY)
	  If _Sleep(1000) Then ExitLoop
	  ClickControlPos("10.6:39.8");

	  SetLog("Start Quest", $COLOR_DARKGREY)
	  If _Sleep(1000) Then ExitLoop
	  ClickControlPos("72.1:68.6");

	  SetLog("Move Now", $COLOR_DARKGREY)
	  If _Sleep(1000) Then ExitLoop
	  ClickControlPos("72.1:68.6");

	  If _Sleep(1000) Then ExitLoop
	  If CheckAlertPortalScreen() Then
		 SetLog("Go Walk!", $COLOR_DARKGREY)
		 ClickControlPos($POS_SCROLL_QUEST_ALERT_WALK_BUTTON, 1, 1000)
	  Else
		 SetLog("Go!", $COLOR_DARKGREY)
	  EndIf

	  While $RunState

		 UpdateWindowRect()

		 If _IsChecked($checkScrollQuestManualAttackEnabled) = False Then

			; To Walk Fast. It's just for mine, SilverRanger... :)
			ClickControlPos($POS_BATTLE_SKILL1_BUTTON, 2, 500)
		 EndIf

		 $pos = SearchPixel( "15.4:30-21:59.4 | 0xC1CCD9,0x6794C8 | 6" )

		 If IsArray($pos) = False Then
			$pos = SearchPixel( "15.4:30-21:59.4 | 0xDDC4AF,0xCD945D | 6" )
		 EndIf

		 If IsArray($pos) Then
			Local $itemX = $pos[0] - $WinRect[0] + $ThickFrameSize
			Local $itemY = $pos[1] - $WinRect[1] + $NoxTitleBarHeight
			Local $itemPos = [$itemX, $itemY]

			ClickPos($itemPos, 200, 1)

			If _Sleep(1000) Then ExitLoop
			If CheckForPixel("65.9:69.7 | 0x224872, 0x1B406B, 0x6A401A") Then
			   SetLog("Weekly Quest Completed!", $COLOR_PINK)

			   ; Click Complete button
			   ClickControlPos("65.9:69.7 ", 1, 500)
			   $loopCount = $loopCount + 1

			   ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)

			   If _Sleep(1000) Then ExitLoop
			   ExitLoop
			Else
			   SetLog("Wrong Completion Detected", $COLOR_RED)

			   If _Sleep(1000) Then ExitLoop
			   If CheckAlertPortalScreen() Then
				  SetLog("Go Walk!", $COLOR_DARKGREY)
				  ClickControlPos($POS_SCROLL_QUEST_ALERT_WALK_BUTTON, 1, 1000)
			   Else
				  ; Click to start quest again...
				  ClickPos($itemPos, 1, 500)
			   EndIf
			EndIf

		 EndIf

		 If _Sleep($CheckDelay) Then ExitLoop

	  WEnd

   WEnd

   SetLog("WeeklyQuest End", $COLOR_PURPLE)
EndFunc