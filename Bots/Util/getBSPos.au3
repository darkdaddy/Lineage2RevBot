Func getBSPos()
	$aPos = ControlGetPos($HWnD, "", $WindowClass)
	$tPoint = DllStructCreate("int X;int Y")
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	_WinAPI_ClientToScreen(WinGetHandle(WinGetTitle($HWnD)), $tPoint)

	$BSpos[0] = DllStructGetData($tPoint, "X")
	$BSpos[1] = DllStructGetData($tPoint, "Y")
EndFunc   ;==>getBSPos
