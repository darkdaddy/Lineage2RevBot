
Func ClickPos($pos, $delay = 500, $times = 1)
   If _Sleep($delay) Then Return
   Click($pos[0], $pos[1], $times, 200)
EndFunc

Func Click($x, $y, $times = 1, $speed = 0)
   _log($x & "x" & $y & " clicked" )
   If $times <> 1 Then
		For $i = 0 To ($times - 1)
			ControlClick($HWnD, "", "", "left", "1", $x, $y)
			If _Sleep($speed) Then ExitLoop
		Next
	Else
		ControlClick($HWnD, "", "", "left", "1", $x, $y)
	EndIf
EndFunc   ;==>Click

; ClickP : takes an array[2] (or array[4]) as a parameter [x,y]
Func ClickP($point, $howMuch = 1, $speed = 0)
	Click($point[0], $point[1], $howMuch, $speed)
EndFunc   ;==>ClickP


Func ClickButtonImage($btnPath, $check = True)
   Local $bound = [0, 0, $WinRect[2], $WinRect[3]]
   Return ClickButtonImageArea($btnPath, $bound, $check)
EndFunc	;==>ClickButtonImage


Func ClickButtonImageArea($btnPath, $bound, $check = True)
   Local $ok = False
   Local $x, $y
   While 1
	  If ImageSearchArea($btnPath, 0, $bound, $x, $y, 80) Then
		 ; Click This Button
		 Click($x, $y);
		 _log("Button Clicked Area : " & $btnPath & " - " & $x & " x " & $y )

		 If $check = False Then Return True

		 ; Verify check correctly
		 $ok = True
		 If _Sleep(1200) Then Return False
		  _CaptureRegion()
		 ContinueLoop
	  Else
		 ExitLoop
	  EndIf
   WEnd

   Return $ok
EndFunc	;==>ClickButtonImage