
Func AutoFlow()

   Local Const $TermDelay = 1500

   If $setting_enabled_clean_red_dot Then
	  DoCleanRedDot()
   EndIf

   If $setting_enabled_scrollquest Then
	  If _Sleep($TermDelay) Then Return False
	  DoScrollQuest()
   EndIf

   If $setting_enabled_adena_dungeon Then
	  If _Sleep($TermDelay) Then Return False
	  DoAdenaDungeon()
   EndIf

   If $setting_enabled_pvp Then
	  If _Sleep($TermDelay) Then Return False
	  DoPvPBattle()
   EndIf

   If $setting_enabled_daily_dungeon Then
	  If _Sleep($TermDelay) Then Return False
	  DoDailyDungeon()
   EndIf

   If $setting_enabled_tower_dissipation Then
	  If _Sleep($TermDelay) Then Return False
	  DoOmanTower()
   EndIf

   Return True
EndFunc