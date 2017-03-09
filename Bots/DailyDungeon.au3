
Func DoDailyDungeon()

   Local Const $CastDelay = 300
   SetLog("Daily Dungeon Start", $COLOR_RED)

   $loopCount = 1

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU)

   SetLog("Open Dungeon", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_DUNGEON, 1, 500)

   SetLog("Scrolling pages", $COLOR_DARKGREY)
   If _Sleep(800) Then Return False
   ControlSend($HWnD, "", "",  "ddd")	;Press D D to scroll right
   If _Sleep(800) Then Return False
   ControlSend($HWnD, "", "",  "ddd")	;Press D D to scroll right

   SetLog("Open Daily Dungeon", $COLOR_DARKGREY)
   If _Sleep(1500) Then Return False
   ClickControlPos($POS_DUNGEON_DAILY)

   Local $noTryCount = False
   While $RunState AND $noTryCount = False
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------
	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  If _Sleep(1000) Then Return False
	  If CheckForPixel($CHECK_SCREEN_DAILY_NO_COUNT) Then
		 SetLog("No Try Count", $COLOR_BLUE)

		 ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
		 If _Sleep(500) Then Return
		 ExitLoop
	  EndIf

	  SetLog("Select Difficulty : " & $setting_difficulty_daily, $COLOR_DARKGREY)
	  If _Sleep(1000) Then Return False
	  Switch $setting_difficulty_daily
		 Case 0
			ClickControlPos($POS_DAILY_DUNGEON_DIFFICULTY_EASY, 2, 300)
		 Case 1
			ClickControlPos($POS_DAILY_DUNGEON_DIFFICULTY_NORMAL, 2, 300)
		 Case 2
			ClickControlPos($POS_DAILY_DUNGEON_DIFFICULTY_HARD, 2, 300)
		 Case 3
			ClickControlPos($POS_DAILY_DUNGEON_DIFFICULTY_VERYHARD, 2, 300)
	  EndSwitch

	  SetLog("Entering Dungeon..", $COLOR_DARKGREY)

	  If _Sleep(800) Then Return False
	  ClickControlPos($POS_DUNGEON_DAILY_ENTER_BUTTON)

	  If _Sleep(800) Then Return False
	  If CheckAlertLowPowerScreen() Then
		 SetLog("Low Power Detected", $COLOR_RED)
		 ClickControlPos($POS_ALERT_ALERT_LOW_POWER_CANCEL_BUTTON, 1, 1000)

		 ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
		 If _Sleep(500) Then Return
		 ExitLoop
	  EndIf

	  SetLog("Waiting 5 seconds..", $COLOR_DARKGREY)
	  If _Sleep(5000) Then Return False

	  While $RunState

		 If _Sleep(1500) Then Return False

		 ClickAutoAttackButton()

		 If ActionAttck($CHECK_SCREEN_ADENA_END, 3, False) = False Then

			SetLog("Daily Completed", $COLOR_PINK)
			ClickControlPos($POS_COMMON_FINISH_BUTTON)

			SetLog("Waiting 7 seconds", $COLOR_PINK)
			$loopCount = $loopCount + 1
			If _Sleep(7000) Then Return False
			ExitLoop
		 EndIf
	  WEnd

	  ; TODO
	  ; Just try only one yet.. Do u want more??
	  ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
	  ExitLoop
   WEnd

   SetLog("Adena Dungeon End", $COLOR_PURPLE)
EndFunc