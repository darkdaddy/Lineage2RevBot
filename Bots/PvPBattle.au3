
Func DoPvPBattle()

   SetLog("PvP Battle Start", $COLOR_RED)
   $loopCount = 1

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU)

   SetLog("Open Battle", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_BATTLE)

   SetLog("Open PvP Battle", $COLOR_DARKGREY)
   If _Sleep(1000) Then Return False
   ClickControlPos($POS_BATTLE_PVP)

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------

	; TODO FINISH LOOP
	  ;

	  If _Sleep(2000) Then Return False
	  SetLog("Click Reward", $COLOR_DARKGREY)
	  ClickControlPos($POS_BATTLE_PVP_REWARD)

	  If CheckAlertInfoScreen() Then
		 SetLog("Close Alert", $COLOR_DARKGREY)
		 ClickControlPos($POS_ALERT_INFO_OK_BUTTON, 1, 1000)
	  EndIf

	  If _Sleep(1200) Then Return False
	  SetLog("Refresh List", $COLOR_DARKGREY)
	  ClickControlPos($POS_BATTLE_PVP_REFRESH)

	  If _Sleep(1000) Then Return False
	  SetLog("Battle Start", $COLOR_DARKGREY)
	  ClickControlPos($POS_BATTLE_PVP_LIST_ITEM1)

	  If _Sleep(2000) Then Return False
	  If CheckForPixel($CHECK_SCREEN_PVP_USE_RED_DIA) = True Then
		 SetLog("Alert Need Red Dia", $COLOR_DARKGREY)
		 ClickControlPos($POS_ALERT_ALERT_PVP_USE_RED_DIA_OK_BUTTON)
		 ;$POS_ALERT_ALERT_PVP_USE_RED_DIA_CANCEL_BUTTON
	  EndIf

	  SetLog("Waiting to start battle..", $COLOR_DARKGREY)
	  $waitSec = 0
	  While $waitSec < 10
		 If _Sleep(1000) Then Return False
		 $waitSec = $waitSec + 1
		 If CheckForPixel($CHECK_SCREEN_PVP_START, 30) = True Then
			SetLog("Detected PvP Start Screen", $COLOR_YELLOW)
			ExitLoop
		 EndIf
	  WEnd

	   SetLog("Start battle", $COLOR_DARKGREY)
	  If _Sleep(3000) Then Return False
	  While $RunState

		 If CheckForPixel($CHECK_SCREEN_PVP_FINISH) = True Then
			SetLog("Battle Completed", $COLOR_PINK)
			ClickControlPos($POS_PVP_FINISH_BUTTON)

			If _Sleep(3000) Then Return False
			ExitLoop
		 EndIf

		 If ActionAttck($CHECK_SCREEN_PVP_FINISH, 3) = False Then
			SetLog("Battle Completed", $COLOR_PINK)
			ClickControlPos($POS_PVP_FINISH_BUTTON)

			If _Sleep(3000) Then Return False

			ExitLoop
		 EndIf
	  WEnd
   WEnd

EndFunc