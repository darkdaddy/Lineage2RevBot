Func _Sleep($iDelay, $bAllowPause = True)
   Local $iBegin = TimerInit()
   While TimerDiff($iBegin) < $iDelay
	  If $RunState = False Then Return True
	  While ($PauseBot And $bAllowPause)
		 Sleep(1000)
	  WEnd
	  tabChanged()
	  Sleep(($iDelay > 50) ? 50 : 1)
   WEnd
   Return False
EndFunc   ;==>_Sleep
