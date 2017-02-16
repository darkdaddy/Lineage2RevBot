
Func DoAdenaDungeon()

   Local Const $CastDelay = 300
   SetLog("AdenaDungeon Start", $COLOR_RED)

#cs ----------------------------------------------------------------------------
#ce ----------------------------------------------------------------------------

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU)

   SetLog("Open Dungeon", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_DUNGEON)

   SetLog("Scrolling pages", $COLOR_DARKGREY)
   _Sleep(800)
   ControlSend($HWnD, "", "",  "aaa")	;Press A A to scroll right
   _Sleep(100)
   ControlSend($HWnD, "", "",  "aaa")	;Press A A to scroll right

   SetLog("Open Exp Dungeon", $COLOR_DARKGREY)
   _Sleep(1500)
   ClickControlPos($POS_DUNGEON_ADENA)

   SetLog("Select Difficulty : " & $setting_difficulty_adena, $COLOR_DARKGREY)

   Switch $setting_difficulty_adena
	  Case 0
		 ClickControlPos($POS_DIFFICULTY_EASY, 2, 300)
	  Case 1
		 ClickControlPos($POS_DIFFICULTY_NORMAL, 2, 300)
	  Case 1
		 ClickControlPos($POS_DIFFICULTY_HARD, 2, 300)
   EndSwitch

   SetLog("Entering Dungeon..", $COLOR_DARKGREY)
   _Sleep(800)
   ClickControlPos($POS_DUNGEON_ENTER_BUTTON)

   SetLog("Waiting seconds..", $COLOR_DARKGREY)
   _Sleep(3000)

   ClickControlPos($POS_AUTO_BATTLE_BUTTON)

   While $RunState
	   If _Sleep($CastDelay) Then ExitLoop
	  ClickControlPos($POS_BATTLE_RARE1_BUTTON, 2)
	   If _Sleep($CastDelay) Then ExitLoop
	  ClickControlPos($POS_BATTLE_RARE2_BUTTON, 2)
	   If _Sleep($CastDelay) Then ExitLoop
	  ClickControlPos($POS_BATTLE_SKILL1_BUTTON, 2)
	   If _Sleep($CastDelay) Then ExitLoop
	  ClickControlPos($POS_BATTLE_SKILL2_BUTTON, 2)
	   If _Sleep($CastDelay) Then ExitLoop
	  ClickControlPos($POS_BATTLE_SKILL3_BUTTON, 2)
	   If _Sleep($CastDelay) Then ExitLoop
   WEnd

EndFunc