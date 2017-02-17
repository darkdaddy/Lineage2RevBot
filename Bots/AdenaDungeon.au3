
Func DoAdenaDungeon()

   Local Const $CastDelay = 300
   SetLog("AdenaDungeon Start", $COLOR_RED)

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

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------
	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  SetLog("Open Adena Dungeon", $COLOR_DARKGREY)
	  If _Sleep(1500) Then Return False
	  ClickControlPos($POS_DUNGEON_ADENA)

	  ; TODO FINISH LOOP
	  ;

	  SetLog("Select Difficulty : " & $setting_difficulty_adena, $COLOR_DARKGREY)
	  If _Sleep(1000) Then Return False
	  Switch $setting_difficulty_adena
		 Case 0
			ClickControlPos($POS_DUNGEON_DIFFICULTY_EASY, 2, 300)
		 Case 1
			ClickControlPos($POS_DUNGEON_DIFFICULTY_NORMAL, 2, 300)
		 Case 1
			ClickControlPos($POS_DUNGEON_DIFFICULTY_HARD, 2, 300)
	  EndSwitch

	  SetLog("Entering Dungeon..", $COLOR_DARKGREY)
	  If _Sleep(800) Then Return False
	  ClickControlPos($POS_DUNGEON_ENTER_BUTTON)

	  If _Sleep(800) Then Return False
	  If CheckAlertLowPowerScreen() Then
		 SetLog("Low Power Detected", $COLOR_DARKGREY)
		 ClickControlPos($POS_ALERT_ALERT_LOW_POWER_OK_BUTTON, 1, 1000)
	  EndIf

	  SetLog("Waiting seconds..", $COLOR_DARKGREY)
	  If _Sleep(3000) Then Return False

	  ClickControlPos($POS_AUTO_BATTLE_BUTTON)

	  If _Sleep(3000) Then Return False
	  While $RunState

		 If _Sleep(1500) Then Return False

		 If ActionAttck($CHECK_SCREEN_ADENA_END) = False Then

			SetLog("Adena Completed", $COLOR_PINK)
			ClickControlPos($POS_COMMON_FINISH_BUTTON)

			$loopCount = $loopCount + 1
			If _Sleep(4000) Then Return False
			ExitLoop
		 EndIf
	  WEnd

   WEnd

EndFunc