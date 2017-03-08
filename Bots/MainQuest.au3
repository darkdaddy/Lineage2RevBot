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

   Local Const $CheckDelay = 1000

   $loopCount = 1

   StartMainQuest()

   SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)

   While $RunState
#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------

	  If CheckForPixel($CHECK_SCREEN_SKIP) = True Then
		 ; Click any skip button!
		 ClickControlPos($POS_SKIP_BUTTON)
		 If _Sleep(1000) Then ExitLoop
	  EndIf

	  If CheckForPixel($CHECK_SCREEN_SCROLLQUEST_START) Then
		 SetLog("Start Quest", $COLOR_DARKGREY)
		 ClickControlPos($POS_SCROLL_QUEST_START_BUTTON, 1, 1000)

		 If _Sleep(1000) Then ExitLoop
		 ContinueLoop
	  EndIf

	  If CheckAlertPortalScreen() Then
		 SetLog("Go Walk!", $COLOR_DARKGREY)
		 ClickControlPos($POS_SCROLL_QUEST_ALERT_WALK_BUTTON, 1, 1000)

		 If _Sleep(1000) Then ExitLoop
		 ContinueLoop
	  EndIf

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
		 $completedQuest = True
	  EndIf

	  ; Checking Episode completion
	  If CheckForPixel("77.4:88.3, 87.9:88.3 | 0x224872, 0x1B406B, 0x6A401A | 8") Then
		 SetLog("Episode Completed", $COLOR_DARKGREY)
		 ClickControlPos("77.4:88.3", 1, 1000)

		 SetLog("Waiting 10 sec...", $COLOR_PINK)
		 If _Sleep(10000) Then ExitLoop

		 $completedQuest = True
	  EndIf

	  If $completedQuest Then
		 If _Sleep(1000) Then ExitLoop
		 StartMainQuest()

		 $loopCount = $loopCount + 1
		 SetLog("LoopCount : " & $loopCount, $COLOR_GREEN)
	  EndIf

	   If _Sleep($CheckDelay) Then ExitLoop
   WEnd

   SetLog("MainQuest End", $COLOR_PURPLE)
EndFunc