Global $Initiate = 0

Local $tabX = 10
Local $tabY = 10
Local $contentPaneX = $tabX + 10
Local $contentPaneY = $tabY + 30

Local $gap = 10
Local $generalRightHeight = 240
Local $generalBottomHeight = 70
Local $logViewWidth = 260
Local $logViewHeight = 300
Local $frameWidth = $contentPaneX + $logViewWidth + $gap + $generalRightHeight + $tabX
Local $frameHeight = $contentPaneY + $logViewHeight + $gap + $generalBottomHeight + $tabY

Local $tabHeight = $frameHeight - $tabY - $tabY
Local $contentPaneWidth = $frameWidth - $contentPaneX * 2
Local $contentPaneHeight = $tabHeight - 30
Local $x
Local $y
Local $h = 20
Local $w = 150

; Main GUI Settings
$mainView = GUICreate($sBotTitle, $frameWidth, $frameHeight, -1, -1)

$idTab = GUICtrlCreateTab($tabX, $tabY, $frameWidth - $tabX * 2, $tabHeight)


;-----------------------------------------------------------
; Tab : General
;-----------------------------------------------------------
Local $generalRightX = $frameWidth - $tabX - $generalRightHeight
Local $generalBottomY = $frameHeight - $tabY - $generalBottomHeight

GUICtrlCreateTabItem("General")

$x = $generalRightX
$y = $contentPaneY + 5

$checkScrollQuestEnabled = GUICtrlCreateCheckbox("Scroll Quest", $x, $y, $w, 25)
$y += 30

GUICtrlCreateLabel("Scroll Pos", $x, $y)
$comboScrollPos = GUICtrlCreateCombo("", $x + 70, $y - 5, 100, $h)
For $i = 1 To 6
   GUICtrlSetData($comboScrollPos, "Item - " & $i)
Next
_GUICtrlComboBox_SetCurSel($comboScrollPos, 1)
$y += 30

$checkPvpEnabled = GUICtrlCreateCheckbox("PVP", $x, $y, $w, 25)
$y += 30
$checkDailyDungeonEnabled = GUICtrlCreateCheckbox("Daily Dungeon", $x, $y, $w, 25)

$y += 30
$checkAdenaEnabled = GUICtrlCreateCheckbox("Adena Dungeon", $x, $y, $w, 25)
$y += 30
GUICtrlCreateLabel("Difficulty", $x, $y)
$comboAdenaDifficulty = GUICtrlCreateCombo("", $x + 70, $y - 5, 100, $h)
GUICtrlSetData($comboAdenaDifficulty, "Easy")
GUICtrlSetData($comboAdenaDifficulty, "Normal")
GUICtrlSetData($comboAdenaDifficulty, "Hard")
_GUICtrlComboBox_SetCurSel($comboAdenaDifficulty, 2)

$y += 30
$checkExpEnabled = GUICtrlCreateCheckbox("Exp Dungeon", $x, $y, $w, 25)
$y += 30
GUICtrlCreateLabel("Difficulty", $x, $y)
$comboExpDifficulty = GUICtrlCreateCombo("", $x + 70, $y - 5, 100, $h)
GUICtrlSetData($comboExpDifficulty, "Easy")
GUICtrlSetData($comboExpDifficulty, "Normal")
GUICtrlSetData($comboExpDifficulty, "Hard")
_GUICtrlComboBox_SetCurSel($comboExpDifficulty, 2)

$y += 30
$checkTowerDissipationEnabled = GUICtrlCreateCheckbox("Tower Dissipation", $x, $y, $w, 25)

; The Bot Status Screen
$txtLog = _GUICtrlRichEdit_Create($mainView, "", $contentPaneX, $contentPaneY, $logViewWidth, $logViewHeight, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8912))

; Start/Stop Button
$x = $contentPaneX
Local $btnWidth = 90
$btnStart = GUICtrlCreateButton("Start Bot", $x, $generalBottomY, $btnWidth, 50)
$btnStop = GUICtrlCreateButton("Stop Bot", $x, $generalBottomY, $btnWidth, 50)

$x += $btnWidth
$x += $gap
; TODO : add button


;==================================
; Control Initial setting
;==================================

GUICtrlSetOnEvent($btnStart, "btnStart")
GUICtrlSetOnEvent($btnStop, "btnStop")	; already handled in GUIControl
GUICtrlSetOnEvent($idTab, "tabChanged")

GUICtrlSetState($btnStart, $GUI_SHOW)
GUICtrlSetState($btnStop, $GUI_HIDE)

GUISetState(@SW_SHOW, $mainView)


;==================================
; Control Callback
;==================================

Func tabChanged()
   If _GUICtrlTab_GetCurSel($idTab) = 0 Then
	  ControlShow($mainView, "", $txtLog)
   Else
	  ControlHide($mainView, "", $txtLog)
   EndIf
EndFunc

Func btnStart()
   _log("START BUTTON CLICKED" )

   _GUICtrlEdit_SetText($txtLog, "")
   _WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; Reduce Nox Memory Usage

   $RunState = True
   $PauseBot = False

   GUICtrlSetState($btnStart, $GUI_HIDE)
   GUICtrlSetState($btnStop, $GUI_SHOW)

   If findWindow() Then
	  WinActivate($HWnD)
	  SetLog("Rect : " & $WinRect[0] & "," & $WinRect[1] & " " & $WinRect[2] & "x" & $WinRect[3] , $COLOR_ORANGE)
   Else
	  SetLog("Nox Not Found", $COLOR_RED)
   EndIf

   saveConfig()

   runBot()

EndFunc

Func btnStop()
   If $RunState = False Then
	  Return
   EndIf

   _log("STOP BUTTON CLICKED" )

   GUICtrlSetState($btnStart, $GUI_SHOW)
   GUICtrlSetState($btnStop, $GUI_HIDE)

   $Restart = False
   $RunState = False
   $PauseBot = True

   SetLog("Bot has stopped", $COLOR_ORANGE)
EndFunc

; System callback
Func mainViewClose()
   saveConfig()
   _GDIPlus_Shutdown()
   _GUICtrlRichEdit_Destroy($txtLog)
   Exit
EndFunc
