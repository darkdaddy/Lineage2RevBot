
Func AutoFlow()

   Local Const $TermDelay = 1500

   If $setting_enabled_mainquest Then
	  DoMainQuest()
	  If _Sleep($TermDelay) Then Return False
   EndIf

   If $setting_enabled_scrollquest Then
	  DoScrollQuest()
  	  If _Sleep($TermDelay) Then Return False
   EndIf

   If $setting_enabled_adena_dungeon Then
	  DoAdenaDungeon()
	  If _Sleep($TermDelay) Then Return False
   EndIf

   If $setting_enabled_pvp Then
	  DoPvPBattle()
   	  If _Sleep($TermDelay) Then Return False
   EndIf

   If $setting_enabled_daily_dungeon Then
	  DoDailyDungeon()
   	  If _Sleep($TermDelay) Then Return False
   EndIf

   If $setting_enabled_tower_dissipation Then
	  If _Sleep($TermDelay) Then Return False
	  DoOmanTower()
   EndIf

   If $setting_enabled_weeklyquest Then
	  If _Sleep($TermDelay) Then Return False
	  DoWeeklyQuest()
   EndIf

   Return True
EndFunc