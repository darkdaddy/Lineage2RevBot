#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------


Func CheckWeeklyQuestCompletionScreen()

   Local Const $QuestCompleteButton = "65.9:69.7"
   Local Const $WeeklyQuestCompleteScreen = "65.9:69.7 | 0x224872, 0x1B406B, 0x6A401A"

   If CheckForPixel($WeeklyQuestCompleteScreen) Then
	  SetLog("Weekly Quest Completed!", $COLOR_PINK)

	  ; Click Complete button
	  ClickControlPos($QuestCompleteButton, 1, 500)
	  ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
	  Return True
   EndIf
   Return False
EndFunc

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

	  ; Check Quest Completion Button
	  SetLog("Waiting 3sec..", $COLOR_DARKGREY)
	  Local $questCompleted = False
	  Local $noQuestCount = False
 	  For $i = 1 To 3
		 If _Sleep(1000) Then ExitLoop
		 If CheckWeeklyQuestCompletionScreen() Then
			If _Sleep(1000) Then ExitLoop
			$loopCount = $loopCount + 1
			$questCompleted = True
			ExitLoop
		 EndIf

		 ; Check Quest Not Available
		 If CheckForPixel("65.3:68.3, 78.3:68.3 | 0x17202F, 0x151A25 | 6") Then
			SetLog("No Weekly Quest", $COLOR_RED)
			ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)
			$noQuestCount = True
			ExitLoop
		 EndIf
	  Next

	  If $questCompleted Then
		 ContinueLoop
	  EndIf

	  If $noQuestCount Then
		 ExitLoop
	  EndIf

	  If _Sleep(1000) Then ExitLoop
	  SetLog("Start Quest", $COLOR_DARKGREY)
	  ClickControlPos("72.1:68.6");

	  If _Sleep(1500) Then ExitLoop
	  If CheckAlertPortalScreen() Then
		 SetLog("Go Walk!", $COLOR_DARKGREY)
		 ClickControlPos($POS_SCROLL_QUEST_ALERT_WALK_BUTTON, 1, 1000)
	  Else
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
	  EndIf

	  ClickControlPos($POS_BATTLE_SKILL1_BUTTON, 2, 500)

	  ; Waiting to complete one weekly quest
	  While $RunState

		 UpdateWindowRect()

		 ; Finding "Completion" Circle on Quest Board (in Left Screen)
		 $pos = SearchPixel( "15.4:41.6-21:59.4 | 0xC1CCD9,0x6794C8 | 6" )

		 If IsArray($pos) = False Then
			$pos = SearchPixel( "15.4:41.6-21:59.4 | 0xDDC4AF,0xCD945D | 10" )
		 EndIf

		 If IsArray($pos) Then
			Local $itemX = $pos[0] - $WinRect[0] + $ThickFrameSize
			Local $itemY = $pos[1] - $WinRect[1] + $NoxTitleBarHeight
			Local $itemPos = [$itemX, $itemY]

			ClickPos($itemPos, 200, 1)

			If _Sleep(1500) Then ExitLoop
			If CheckWeeklyQuestCompletionScreen() Then

			   $loopCount = $loopCount + 1

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
				  SetLog("Go Again!", $COLOR_GREEN)
				  ClickPos($itemPos, 500, 1)
			   EndIf
			EndIf

		 EndIf

		 If _Sleep($CheckDelay) Then ExitLoop

	  WEnd

   WEnd

   SetLog("WeeklyQuest End", $COLOR_PURPLE)
EndFunc