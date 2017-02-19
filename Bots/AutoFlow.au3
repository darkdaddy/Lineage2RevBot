
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

   If $setting_enabled_daily_dungeon Then
	  DoDailyDungeon()
   EndIf

   If $setting_enabled_tower_dissipation Then
	  DoOmanTower()
   EndIf

   Return True
EndFunc