
Func DoPvPBattle()

   SetLog("PvP Battle Start", $COLOR_RED)
   $loopCount = 1

#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU)
   If _Sleep(500) Then Return False

   SetLog("Open Battle", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_BATTLE, 1, 500)

   SetLog("Open PvP Battle", $COLOR_DARKGREY)
   If _Sleep(1500) Then Return False
   ClickControlPos($POS_BATTLE_PVP)

   SetLog("Clean Up PVP", $COLOR_DARKGREY)
   ClickControlPos($POS_BACK_LEFT_BUTTON, 1, 1000)

   SetLog("Open PvP Battle", $COLOR_DARKGREY)
   If _Sleep(1000) Then Return False
   ClickControlPos($POS_BATTLE_PVP)

   Local $finishFlag = False

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------
	  If _Sleep(1000) Then Return False

	  saveConfig()
	  loadConfig()

	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  If _Sleep(1200) Then Return False
	  SetLog("Refresh List", $COLOR_DARKGREY)
	  ClickControlPos($POS_BATTLE_PVP_REFRESH)

	  SetLog("Checking Try Count", $COLOR_DARKGREY)
	  If CheckForPixel($CHECK_SCREEN_PVP_NO_COUNT) = True Then
		 SetLog("No Try Count", $COLOR_PINK)

		 $finishFlag = True
		 ExitLoop
	  EndIf

	  If _Sleep(1000) Then Return False
	  SetLog("Battle Start", $COLOR_DARKGREY)
	  ClickControlPos($POS_BATTLE_PVP_LIST_ITEM4)

	  If _Sleep(2000) Then Return False
	  If CheckForPixel($CHECK_SCREEN_PVP_USE_RED_DIA) = True Then

		 If $setting_pvp_use_red_dia Then
			SetLog("Use Red Dia", $COLOR_RED)
			ClickControlPos($POS_ALERT_ALERT_PVP_USE_RED_DIA_OK_BUTTON)
		 Else
			SetLog("Don't Use Red Dia", $COLOR_DARKGREY)
			ClickControlPos($POS_ALERT_ALERT_PVP_USE_RED_DIA_CANCEL_BUTTON)

			$finishFlag = True
			ExitLoop
		 EndIf
	  EndIf

	  SetLog("Waiting to start battle..", $COLOR_DARKGREY)
	  $waitSec = 0
	  While $waitSec < 10
		 If _Sleep(1000) Then Return False
		 $waitSec = $waitSec + 1
		 If CheckForPixel($CHECK_SCREEN_PVP_START, 30) = True Then
			SetLog("Detected PvP Start Screen", $COLOR_DARKGREY)
			ExitLoop
		 EndIf
	  WEnd

	  SetLog("Start battle", $COLOR_DARKGREY)

	  If _Sleep(500) Then Return False
	  MoveTopRoundTravel()

	  While $RunState

		 If CheckForPixel($CHECK_SCREEN_PVP_END) = True Then
			SetLog("Battle Completed", $COLOR_PINK)
			ClickControlPos($POS_COMMON_FINISH_BUTTON)

			If _Sleep(4000) Then Return False
			ExitLoop
		 EndIf

		 If ActionAttck($CHECK_SCREEN_PVP_END, 3) = False Then
			SetLog("Battle Completed", $COLOR_PINK)
			ClickControlPos($POS_COMMON_FINISH_BUTTON)

			If _Sleep(4000) Then Return False

			$loopCount = $loopCount + 1
			ExitLoop
		 EndIf
	  WEnd
   WEnd

   If $finishFlag Then

	  SetLog("Click Reward", $COLOR_DARKGREY)
	  ClickControlPos($POS_BATTLE_PVP_REWARD)

	  If _Sleep(1000) Then Return False
	  ClickControlPos($POS_ALERT_ALERT_PVP_REWARD_BUTTON)

	  ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
	  If _Sleep(500) Then Return False
   EndIf

   SetLog("PVP End", $COLOR_PURPLE)
EndFunc