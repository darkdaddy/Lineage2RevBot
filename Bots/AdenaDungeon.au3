
Func DoAdenaDungeon()

   Local Const $CastDelay = 300
   SetLog("Adena Dungeon Start", $COLOR_RED)

   $loopCount = 1

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU)

   SetLog("Open Dungeon", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_DUNGEON)

   SetLog("Scrolling pages", $COLOR_DARKGREY)
   If _Sleep(800) Then Return False
   ControlSend($HWnD, "", "",  "aaa")	;Press A A to scroll right
   If _Sleep(800) Then Return False
   ControlSend($HWnD, "", "",  "aaa")	;Press A A to scroll right

   SetLog("Open Adena Dungeon", $COLOR_DARKGREY)
   If _Sleep(1500) Then Return False
   ClickControlPos($POS_DUNGEON_ADENA)

   Local $noTryCount = False
   While $RunState AND $noTryCount = False
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------
	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  If _Sleep(1000) Then Return False
	  If CheckForPixel($CHECK_SCREEN_ADENA_NO_COUNT) Then
		 SetLog("No Try Count", $COLOR_BLUE)

		 ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
		 If _Sleep(500) Then Return
		 ExitLoop
	  EndIf

	  SetLog("Select Difficulty : " & $setting_difficulty_adena, $COLOR_DARKGREY)
	  If _Sleep(1000) Then Return False
	  Switch $setting_difficulty_adena
		 Case 0
			ClickControlPos($POS_DUNGEON_DIFFICULTY_EASY, 2, 300)
		 Case 1
			ClickControlPos($POS_DUNGEON_DIFFICULTY_NORMAL, 2, 300)
		 Case 2
			ClickControlPos($POS_DUNGEON_DIFFICULTY_HARD, 2, 300)
	  EndSwitch

	  SetLog("Entering Dungeon..", $COLOR_DARKGREY)
	  If _Sleep(800) Then Return False
	  ClickControlPos($POS_DUNGEON_ADENA_ENTER_BUTTON)

	  If _Sleep(800) Then Return False
	  If CheckAlertLowPowerScreen() Then
		 SetLog("Low Power Detected", $COLOR_RED)
		 ClickControlPos($POS_ALERT_ALERT_LOW_POWER_CANCEL_BUTTON, 1, 1000)

		 ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
		 If _Sleep(500) Then Return
		 ExitLoop
	  EndIf

	  SetLog("Waiting seconds..", $COLOR_DARKGREY)
	  If _Sleep(3000) Then Return False

	  SetLog("Auto Attck Button Click", $COLOR_DARKGREY)
	  ClickControlPos($POS_AUTO_BATTLE_BUTTON, 1, 200)

	  If _Sleep(3000) Then Return False
	  While $RunState

		 If _Sleep(1500) Then Return False

		 If ActionAttck($CHECK_SCREEN_ADENA_END, 3) = False Then

			SetLog("Adena Completed", $COLOR_PINK)
			If _Sleep(1000) Then Return False
			ClickControlPos($POS_COMMON_FINISH_BUTTON, 1, 300)

			SetLog("Waiting 7 seconds", $COLOR_PINK)
			$loopCount = $loopCount + 1
			If _Sleep(7000) Then Return False

			If CheckForPixel($CHECK_SCREEN_COMMON_DUNGEON_MAIN) = False Then
			   SetLog("No Try Count", $COLOR_PINK)
			   $noTryCount = True

			   GoBackToMain()
			EndIf

			ExitLoop
		 EndIf
	  WEnd

   WEnd

   SetLog("Adena Dungeon End", $COLOR_PURPLE)
EndFunc