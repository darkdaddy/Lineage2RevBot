#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GUIEdit.au3>
#include <GUIComboBox.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIProc.au3>
#include <ScreenCapture.au3>
#include <Date.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>
#include <GUIMenu.au3>
#include <ColorConstants.au3>
#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <GuiTab.au3>
#include <WinAPISys.au3>

Global Const $64Bit = StringInStr(@OSArch, "64") > 0

Global Const $NoxTitleBarHeight = 36
Global Const $ThickFrameSize = 2
Global Const $MinWinSize = 200
Global $WinRect = [0, 0, 0, 0]
Global $WindowClass = "[Qt5QWindowIcon]"
Global $Title

Global $PosXYSplitter = ":"

Global $HWnD = WinGetHandle($Title) ;Handle for Bluestacks window

Global $Compiled
If @Compiled Then
	$Compiled = "Executable"
Else
	$Compiled = "Au3 Script"
EndIf

Global $sLogPath ; `Will create a new log file every time the start button is pressed
Global $hLogFileHandle
Global $Restart = False
Global $RunState = False
Global $PauseBot = False

Global $hBitmap; Image for pixel functions
Global $hHBitmap; Handle Image for pixel functions

Global $dirLogs = @ScriptDir & "\logs\"
Global $dirCapture = @ScriptDir & "\capture\"
Global $ReqText
Global $config = @ScriptDir & "\config.ini"

Global $BSpos[2] ; Inside BlueStacks positions relative to the screen

Global Const $RetryWaitCount = 30
Global Const $SleepWaitMSec = 1500
Global Const $DefaultTolerance = 30

; ---------- COLORS ------------
Global Const $COLOR_ORANGE = 0xFFA500
Global Const $COLOR_PINK = 0xFFAEC9
Global Const $COLOR_DARKGREY = 0x555555


; ---------- Positions ------------
Global const $POS_TOPMENU_MENU = "71.2:4.8"
Global const $POS_TOPMENU_BAG = "76.1:4.5"

Global const $POS_MENU_DUNGEON = "18.3:91.5"
Global const $POS_MENU_BATTLE = "30.8:91.5"

Global const $POS_DUNGEON_ADENA = "64.9:56.3"
Global const $POS_DUNGEON_EXP = "85.3:56.3"
Global const $POS_DUNGEON_ENTER_BUTTON = "77.9:89.6"

Global const $POS_BATTLE_PVP = "28.2:54.8"

Global const $POS_BATTLE_PVP_REWARD = "40.5:22"
Global const $POS_BATTLE_PVP_REFRESH = "90.7:17.3"
Global const $POS_BATTLE_PVP_LIST_ITEM1 = "91.1:32.2"

Global const $POS_DUNGEON_DIFFICULTY_EASY = "25.1:31"
Global const $POS_DUNGEON_DIFFICULTY_NORMAL = "25.1:45.2"
Global const $POS_DUNGEON_DIFFICULTY_HARD = "25.1:60.3"

Global const $POS_DAILY_DUNGEON_DIFFICULTY_EASY = "15.5:36.9"
Global const $POS_DAILY_DUNGEON_DIFFICULTY_NORMAL = "15.5:52.2"
Global const $POS_DAILY_DUNGEON_DIFFICULTY_HARD = "15.5:67.4"
Global const $POS_DAILY_DUNGEON_DIFFICULTY_VERYHARD = "15.5:83.7"

Global const $POS_BAG_MISC_TAB = "85.8:17.3"
Global const $POS_BAG_ITEM_LEFT = "51.4:25.3"
Global const $POS_BAG_ITEM_RIGHT = "96.7:25.3"

Global const $POS_EXIT_RIGHT_BUTTON = "96.2:5.2"

Global const $POS_SCROLL_QUEST_REQUEST_BUTTON = "87.8:92.9"
Global const $POS_SCROLL_QUEST_START_BUTTON = [54.6, 88.5]
Global const $POS_SCROLL_QUEST_GUIDE_BUTTON = [9.5, 55.0]
Global const $POS_SCROLL_QUEST_ALERT_WALK_BUTTON = [32.7, 77.0]
Global const $POS_SCROLL_QUEST_END_BUTTON = [44.0, 88.0]

Global const $POS_ALERT_QUESTION_OK_BUTTON = [56.8, 73.5]
Global const $POS_ALERT_INFO_OK_BUTTON = "49.9:65.7"	; single OK alert
Global const $POS_ALERT_ALERT_LOW_POWER_OK_BUTTON = [53.5, 75.5]
Global const $POS_ALERT_ALERT_PVP_USE_RED_DIA_OK_BUTTON = [53.5, 72.4]
Global const $POS_ALERT_ALERT_PVP_USE_RED_DIA_CANCEL_BUTTON = [37.2, 72.4]
Global const $POS_ALERT_ALERT_ADVERTISING_CLOSE_BUTTON = [85.8, 30.1]
Global const $POS_SKIP_BUTTON = [91.1, 74.8]

Global const $POS_AUTO_BATTLE_BUTTON = [66.9, 92.8]
Global const $POS_BATTLE_RARE1_BUTTON = [88.0, 67.4]
Global const $POS_BATTLE_RARE2_BUTTON = [94.9, 68.7]
Global const $POS_BATTLE_SKILL1_BUTTON = [81.6, 71.2]
Global const $POS_BATTLE_SKILL2_BUTTON = [79.4, 82.0]
Global const $POS_BATTLE_SKILL3_BUTTON = [80.4, 92.5]
Global const $POS_BATTLE_ATTACK_BUTTON = [90.1, 83.4]

Global const $POS_PVP_FINISH_BUTTON = [72.0, 91.2]

; ---------- Screen Check ------------
Global const $CHECK_SCREEN_SKIP = "85.6:97.5 | 0x000000"
Global const $CHECK_SCREEN_PVP_START = "41.4:12.6 | 0xD00101,0xA51B06"	; red
Global const $CHECK_SCREEN_PVP_FINISH = "72.0:91.2 | 0x224872,0x1B406B,0x6A401A"	; blue
Global const $CHECK_SCREEN_PVP_USE_RED_DIA = "53.5:72.4 | 0x224872,0x1B406B,0x6A401A"	; blue
Global const $CHECK_SCREEN_PVP_NO_COUNT = "87.1:38.7 | 0x27201E"	; darkgrey
Global const $CHECK_SCREEN_ALERT_INFO = "45.5:71.5 | 0x224872,0x1B406B,0x6A401A"	; blue
Global const $CHECK_SCREEN_ALERT_LOW_POWER = "53.5:75.5 | 0x224872, 0x1B406B, 0x6A401A"	; blue
Global const $CHECK_SCREEN_PORTALALERT = "53.5:75.5 | 0x224872, 0x1B406B, 0x6A401A"	; blue
Global const $CHECK_SCREEN_SCROLLQUEST_END = "44.0:88.0, 60.0:88.0 | 0x224872, 0x1B406B, 0x6A401A"	; blue
Global const $CHECK_SCREEN_ADVERTISING = "85.8:30.1 | 0xA4A1A4 | 5"	; grey 'X'