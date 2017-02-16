
Func AutoFlow()

   If $setting_enabled_scrollquest Then
	  DoScrollQuest()
   EndIf

   If $setting_enabled_adena_dungeon Then
	  DoAdenaDungeon()
   EndIf

   Return True
EndFunc