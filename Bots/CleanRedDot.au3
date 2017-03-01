
Func DoCleanRedDot()

   Local Const $DefaultDelay = 800
   SetLog("Clean Red Dot Start", $COLOR_RED)

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU, 1, $DefaultDelay)

   ;---------------------------------------------------
   ; 혈맹
   If _Sleep(1000) Then Return
   SetLog("Open GUILD", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_GUILD, 1, $DefaultDelay)

   ; 출석체크
   ClickControlPos("62.8:73.6", 1, 1000)
   ClickControlPos("63.9:72.4", 1, 1000)
   ClickControlPos("49.3:68.7", 1, 1000)

   ; 아덴 기부하기
   ClickControlPos("85.7:74.2", 1, 1000)
   ClickControlPos("49.7:84.4", 1, 1000)

   ; 혈맹원 인사
   ClickControlPos("49.1:16.3", 1, 1000)
   ClickControlPos("73.3:94.5", 1, 1000)
   If _Sleep(1000) Then Return
   If CheckAlertInfoScreen() Then
	  ClickControlPos($POS_ALERT_INFO_OK_BUTTON, 1, 1000)
   EndIf
   ClickControlPos("83.3:94.5", 1, 1000)
   If _Sleep(1000) Then Return
   If CheckAlertInfoScreen() Then
	  ClickControlPos($POS_ALERT_INFO_OK_BUTTON, 1, 1000)
   EndIf
   ClickControlPos($POS_BACK_LEFT_BUTTON, 1, $DefaultDelay)

   ;---------------------------------------------------
   ; 업적
   ClickControlPos($POS_MENU_CHALLENGE, 1, $DefaultDelay)
   If _Sleep(1000) Then Return
   SetLog("Open Achievement", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_CHALLENGE_ACHIEVEMENT, 1, $DefaultDelay)

   SetLog("Get Today Rewards", $COLOR_DARKGREY)
   If _Sleep(2000) Then Return
   ClickControlPos($POS_MENU_CHALLENGE_ACHIEVEMENT_TODAY_REWARD_BUTTON, 1, $DefaultDelay)
   ClickControlPos($POS_BACK_LEFT_BUTTON, 1, $DefaultDelay)

   ;---------------------------------------------------
   ; 오늘의 활동
   ClickControlPos($POS_MENU_CHALLENGE, 1, $DefaultDelay)
   If _Sleep(1000) Then Return
   SetLog("Open Today Activity", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_CHALLENGE_TODAY_ACTIVITY, 1, $DefaultDelay)

   SetLog("Get Today Rewards", $COLOR_DARKGREY)
   If _Sleep(2000) Then Return
   ClickControlPos($POS_MENU_CHALLENGE_TODAY_ACTIVITY_REWARD_BUTTON, 10, 300)
   ClickControlPos($POS_BACK_LEFT_BUTTON, 1, $DefaultDelay)

   SetLog("Clean Red Dot End", $COLOR_PURPLE)
EndFunc