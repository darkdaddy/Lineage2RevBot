#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func DoScrollQuest()

   SetLog("ScrollQuest Start", $COLOR_RED)

   Local Const $CheckDelay = 2000

   $loopCount = 1

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------

	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  SetLog("Open Bag", $COLOR_DARKGREY)
	  ClickControlPos($POS_TOPMENU_BAG)

	   If _Sleep(2000) Then ExitLoop
	  SetLog("Checking Advertising", $COLOR_DARKGREY)
	  CloseAdvertisingScreen()

	  SetLog("Open Misc Tab", $COLOR_DARKGREY)
	  ClickControlPos($POS_BAG_MISC_TAB, 3)

	  ; One More Check
	  CloseAdvertisingScreen()

	  SetLog("Use Scroll", $COLOR_DARKGREY)
	  ClickBagItem($setting_item_pos_questscroll)

	  SetLog("Request Quest", $COLOR_DARKGREY)
	  ClickControlPos($POS_SCROLL_QUEST_REQUEST_BUTTON, 1, 500)
	  ClickControlPos($POS_ALERT_QUESTION_OK_BUTTON, 1, 1000)

	  If CheckAlertInfoScreen() Then
		 SetLog("No Try Count", $COLOR_DARKGREY)
		 ClickControlPos($POS_ALERT_INFO_OK_BUTTON, 1, 1000)

		 ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
		 ExitLoop
	  EndIf

	  SetLog("Start Quest", $COLOR_DARKGREY)
	  ClickControlPos($POS_SCROLL_QUEST_START_BUTTON, 1, 1000)

	  ; Wait some seconds for checking what screen will show..
	  If _Sleep(2000) Then ExitLoop

	  If CheckAlertPortalScreen() Then
		 SetLog("Go Walk!", $COLOR_DARKGREY)
		 ClickControlPos($POS_SCROLL_QUEST_ALERT_WALK_BUTTON, 1, 1000)
	  Else
		 SetLog("Go!", $COLOR_DARKGREY)
	  EndIf

	  While $RunState

		 UpdateWindowRect()

		  ; Click any skip button!
		 ClickControlPos($POS_SKIP_BUTTON)

		 If CheckScrollQuestEndScreen() Then
			ClickControlPos($POS_SCROLL_QUEST_END_BUTTON)
			SetLog("Scroll Quest Completed!", $COLOR_PINK)
			$loopCount = $loopCount + 1
			ExitLoop
		 EndIf

		 If _Sleep($CheckDelay) Then ExitLoop

	  WEnd

   WEnd

   SetLog("ScrollQuest End", $COLOR_PURPLE)
EndFunc