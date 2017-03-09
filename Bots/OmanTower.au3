
Func DoOmanTower()

   Local Const $CastDelay = 300
   SetLog("AdenaDungeon Start", $COLOR_RED)

   $loopCount = 1

   SetLog("Open Menu", $COLOR_DARKGREY)
   ClickControlPos($POS_TOPMENU_MENU)
   If _Sleep(500) Then Return False

   SetLog("Open Dungeon", $COLOR_DARKGREY)
   ClickControlPos($POS_MENU_DUNGEON)
   If _Sleep(500) Then Return False

   SetLog("Scrolling pages", $COLOR_DARKGREY)
   If _Sleep(800) Then Return False
   ControlSend($HWnD, "", "",  "ddd")	;Press D D to scroll right
   If _Sleep(800) Then Return False
   ControlSend($HWnD, "", "",  "ddd")	;Press D D to scroll right

   SetLog("Open Oman's Tower", $COLOR_DARKGREY)
   If _Sleep(1000) Then Return False
   ClickControlPos($POS_DUNGEON_OMANTOWER)

   If _Sleep(4000) Then Return False
   SetLog("Dissipation!", $COLOR_BLUE)
   ClickControlPos($POS_OMAN_DISSIPATION_BUTTON)

   If _Sleep(2500) Then Return False
   ClickControlPos($POS_EXIT_RIGHT_BUTTON, 1, 1000)

   SetLog("Oman's Tower End", $COLOR_PURPLE)
EndFunc