; Functions used to check for certain pixels within a timeout period

; Minimum delay value to use should be 30-50ms to avoid problems on low end PCs

Func _WaitForPixel($iX, $iY, $nColor, $tolerance = 5, $iTimeout = 1000, $iDelay = 100)
	Return _WaitForPixelCapture(0, 0, $WinRect[2], $WinRect[3], $iX, $iY, $nColor, $tolerance, $iTimeout, $iDelay)
EndFunc   ;==>_WaitForPixel


Func _WaitForPixelCapture($iLeft, $iTop, $iRight, $iBottom, $iX, $iY, $nColor, $tolerance = 5, $iTimeout = 1000, $iDelay = 100)
	$timer = TimerInit()
	Do
		If _Sleep($iDelay) Then ExitLoop
		_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
		_log("_WaitForPixelCapture : " & $iX & " " & $iY & " " & $iRight & " " &  $iBottom & _GetPixelColor($iX, $iY))
		If _ColorCheck(_GetPixelColor($iX, $iY), $nColor, $tolerance) Then Return True
	Until TimerDiff($timer) > $iTimeout
	Return False
EndFunc   ;==>_WaitForPixelCapture
