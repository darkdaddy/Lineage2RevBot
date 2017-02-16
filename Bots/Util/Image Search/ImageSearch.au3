Func _ImageSearch($findImage, $resultPosition, ByRef $x, ByRef $y, $Tolerance)
	Return _ImageSearchArea($findImage, $resultPosition, 0, 0, $WinRect[2], $WinRect[3], $x, $y, $Tolerance)
EndFunc   ;==>_ImageSearch

Func ImageSearchArea($findImage, $resultPosition, $bound, ByRef $x, ByRef $y, $Tolerance)
   Return _ImageSearchArea($findImage, $resultPosition, $bound[0], $bound[1], $bound[2], $bound[3], $x, $y, $Tolerance)
EndFunc

Func _ImageSearchArea($findImageOrg, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $Tolerance)

	For $i = 1 To 10
   	   Local $findImage = ""

	   If $i <> 1 Then
		  _CaptureRegion()
		 $findImage = StringLeft($findImageOrg, StringLen($findImageOrg) - 4)
		 $findImage = $findImage & "_" & $i & ".bmp"
	   Else
		 $findImage = $findImageOrg
	   EndIf

	   If FileExists($findImage) = False Then
		 Return 0
	   EndIf

	   ;_log("ImageSearchArea Checking : " & $findImage )

	   Global $HBMP = $hHBitmap
	   ;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)

	   If IsString($findImage) Then
		   If $Tolerance > 0 Then $findImage = "*" & $Tolerance & " " & $findImage
		   If $HBMP = 0 Then
			   $result = DllCall(@ScriptDir & "\COCBot.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
		   Else
			   $result = DllCall(@ScriptDir & "\COCBot.dll", "str", "ImageSearchEx", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage, "ptr", $HBMP)
		   EndIf
	   Else
		   $result = DllCall(@ScriptDir & "\COCBot.dll", "str", "ImageSearchExt", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "int", $Tolerance, "ptr", $findImage, "ptr", $HBMP)
		EndIf

	   ; If error exit
	   If IsArray($result) Then
		   If $result[0] = "0" Then
			  ContinueLoop
		   EndIf
	   Else
		   SetLog("Error: Image Search not working...", $COLOR_RED)
		   Return 1
	   EndIf

	   ; Otherwise get the x,y location of the match and the size of the image to
	   ; compute the centre of search
	   $array = StringSplit($result[0], "|")

	   If (UBound($array) >= 4) Then
		   $x = Int(Number($array[2]))
		   $y = Int(Number($array[3]))
		   If $resultPosition = 1 Then
			   $x = $x + Int(Number($array[4]) / 2)
			   $y = $y + Int(Number($array[5]) / 2)
			EndIf
		   _log("ImageSearchArea OK : " & $findImage & " => pos : " & $x & "x" & $y )
		   Return 1
		EndIf
    Next
EndFunc   ;==>_ImageSearchArea
