
Func WaitScreenPixel($colorInfos, $checkOneTime = False)
   Local $checkCount = $checkOneTime = False ? $RetryWaitCount : 0
   For $i = 0 To $checkCount
	  _CaptureRegion()

	  Local $count = 0
	  For $j = 0 To UBound($colorInfos) - 1
		 If _ColorCheck(_GetPixelColor($colorInfos[$j][0], $colorInfos[$j][1]), Hex($colorInfos[$j][2], 6), $colorInfos[$j][3]) = False Then
			If $checkOneTime = False Then
			   If _Sleep($SleepWaitMSec) Then Return False
			EndIf
			ExitLoop
		 Else
			$count = $count + 1
		 EndIf
	  Next

	  If $count = UBound($colorInfos) Then
		 ; Success
		 Return True
	  EndIf
   Next

   If $checkOneTime = False Then $Restart = True

   Return False

EndFunc	;==>WaitScreenPixel

Func WaitScreenImage($image, $bound, $checkOneTime = False)
   Local $checkCount = $checkOneTime = False ? $RetryWaitCount : 0
   For $i = 0 To $checkCount
	  _CaptureRegion()

	  Local $x, $y

	  If _ImageSearchArea($image, 0, $bound[0], $bound[1], $bound[2], $bound[3], $x, $y, $DefaultTolerance) Then
		 ; Success
		 Return True
	  Else
		 If $checkOneTime = False Then
			If _Sleep($SleepWaitMSec) Then Return False
		 EndIf
	  EndIf
   Next

   If $checkOneTime = False Then $Restart = True
   Return False

EndFunc	;==>WaitScreenImage
