
Func SaveImageToFile($tag = "")
   If StringLen($tag) <= 0 Then
	  $tag = "image"
   EndIf

   Local $path = $dirCapture & "\" & $tag & "_" & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & ".bmp"
   _GDIPlus_ImageSaveToFile($hBitmap, $path)
EndFunc