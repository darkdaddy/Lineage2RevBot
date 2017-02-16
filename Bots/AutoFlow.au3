
Func AutoFlow()

   If $setting_enabled_scrollquest Then
	  DoScrollQuest()
   EndIf

   If $setting_enabled_adena_dungeon Then
	  DoAdenaDungeon()
   EndIf

   If $setting_enabled_pvp Then
	  DoPvPBattle()
   EndIf

   Return True
EndFunc