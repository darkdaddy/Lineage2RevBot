#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func StartMainQuest()
   ; Click Main Quest board
   ClickControlPos("4.8:25.5", 1, 300);
   ClickControlPos("9.7:35", 1, 300);
EndFunc

Func DoMainQuest()

   SetLog("MainQuest Start", $COLOR_RED)

   Local Const $CheckDelay = 2000

   $loopCount = 1

   StartMainQuest()

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------
  	  SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

	  If _Sleep(1200) Then ExitLoop
	  If CheckForPixel($CHECK_SCREEN_SKIP) = True Then
		 ; Click any skip button!
		 ClickControlPos($POS_SKIP_BUTTON)
	  EndIf

	  If _Sleep(1000) Then ExitLoop
	  If CheckForPixel($CHECK_SCREEN_SCROLLQUEST_START) Then
		 SetLog("Start Quest", $COLOR_DARKGREY)
		 ClickControlPos($POS_SCROLL_QUEST_START_BUTTON, 1, 1000)
	  EndIf

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

		 If _IsChecked($checkScrollQuestManualAttackEnabled) = False Then

			; Click any skip button!
			ClickControlPos($POS_SKIP_BUTTON)

			; To Walk Fast. It's just for mine, SilverRanger... :)
			ClickControlPos($POS_BATTLE_SKILL1_BUTTON, 2, 500)
		 EndIf

		 If CheckForPixel($CHECK_SCREEN_SKIP) = True Then
			; Click any skip button!
			ClickControlPos($POS_SKIP_BUTTON)
		 EndIf

		 Local $completedQuest = False

		 ; Checking Quest completion
		 If CheckScrollQuestEndScreen() Then
			ClickControlPos($POS_SCROLL_QUEST_END_BUTTON)
			SetLog("Main Quest Completed!", $COLOR_PINK)
			If _Sleep(1000) Then ExitLoop
			$loopCount = $loopCount + 1
			$completedQuest = True
		 EndIf

		 ; Checking Episode completion
		 If CheckForPixel("77.4:88.3, 87.9:88.3 | 0x224872, 0x1B406B, 0x6A401A | 8") Then
			SetLog("Episode Completed", $COLOR_DARKGREY)
			ClickControlPos("7.4:88.3", 1, 1000)

			SetLog("Waiting 6 sec...", $COLOR_PINK)
			If _Sleep(6000) Then ExitLoop

			$completedQuest = True
		 EndIf

		 If $completedQuest Then
			If _Sleep(1000) Then ExitLoop
			StartMainQuest()
			ExitLoop
		 EndIf

		 If _Sleep($CheckDelay) Then ExitLoop

	  WEnd

   WEnd

   SetLog("MainQuest End", $COLOR_PURPLE)
EndFunc