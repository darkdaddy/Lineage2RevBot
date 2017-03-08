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
Global const $POS_TOPMENU_QUEST = "71.2:12.4"

Global const $POS_MENU_DUNGEON = "18.3:91.5"
Global const $POS_MENU_BATTLE = "30.8:91.5"
Global const $POS_MENU_GUILD = "43.7:91.5"
Global const $POS_MENU_FRIEND = "55.4:91.5"
Global const $POS_MENU_CHALLENGE = "43:7.4"
Global const $POS_MENU_EVENT = "55.4:7.4"
Global const $POS_MENU_SHOP = "67.7:7.4"

Global const $POS_MENU_CHALLENGE_TODAY_ACTIVITY = "32.8:24.5"
Global const $POS_MENU_CHALLENGE_TODAY_ACTIVITY_REWARD_BUTTON = "86.6:25.2"

Global const $POS_MENU_CHALLENGE_ACHIEVEMENT = "46.9:24.5"
Global const $POS_MENU_CHALLENGE_ACHIEVEMENT_TODAY_REWARD_BUTTON = "83:26.1"

Global const $POS_DUNGEON_ADENA = "64.9:60"	; after scroll to right end
Global const $POS_DUNGEON_EXP = "85.3:60"	; after scroll to right end
Global const $POS_DUNGEON_OMANTOWER = "33.9:60"
Global const $POS_DUNGEON_DAILY = "12.6:60"

Global const $POS_BATTLE_PVP = "28.2:54.8"

Global const $POS_BATTLE_PVP_REWARD = "14.1:75.8"
Global const $POS_BATTLE_PVP_REFRESH = "90.7:17.3"
Global const $POS_BATTLE_PVP_LIST_ITEM1 = "90:32"
Global const $POS_BATTLE_PVP_LIST_ITEM4 = "90:87"

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

Global const $POS_BACK_LEFT_BUTTON = "3:5.2"
Global const $POS_EXIT_RIGHT_BUTTON = "96.2:5.2"

Global const $POS_SCROLL_QUEST_REQUEST_BUTTON = "87.8:92.9"
Global const $POS_SCROLL_QUEST_START_BUTTON = "59.5:84.2"
Global const $POS_SCROLL_QUEST_ALERT_WALK_BUTTON = "38.4:71.9"
Global const $POS_SCROLL_QUEST_END_BUTTON = "50.3:84.9"

Global const $POS_ALERT_QUESTION_OK_BUTTON = "58.6:68.3"
Global const $POS_ALERT_INFO_OK_BUTTON = "49.9:65.7"	; single OK alert
Global const $POS_ALERT_ALERT_LOW_POWER_CANCEL_BUTTON = "40:73.1"
Global const $POS_ALERT_ALERT_LOW_POWER_OK_BUTTON = "60:73.1"
Global const $POS_ALERT_ALERT_PVP_REWARD_BUTTON = "32.9:65.8"
Global const $POS_ALERT_ALERT_PVP_USE_RED_DIA_OK_BUTTON = "58.4:69.4"
Global const $POS_ALERT_ALERT_PVP_USE_RED_DIA_CANCEL_BUTTON = "39.6:69.4"
Global const $POS_ALERT_ALERT_ADVERTISING_CLOSE_BUTTON = "85:20.8"
Global const $POS_ALERT_ALERT_ADVERTISING_DO_NOT_SEE_BUTTON = "12.7:80.7"
Global const $POS_SKIP_BUTTON = "93.2:68.6"

Global const $POS_AUTO_BATTLE_BUTTON = "66.3:92.9"
Global const $POS_BATTLE_RARE1_BUTTON = "87.4:63.6"
Global const $POS_BATTLE_RARE2_BUTTON = "94.3:64.5"
Global const $POS_BATTLE_SKILL1_BUTTON = "80.8:67.4"
Global const $POS_BATTLE_SKILL2_BUTTON = "78.3:79.7"
Global const $POS_BATTLE_SKILL3_BUTTON = "79.6:92"
Global const $POS_BATTLE_ATTACK_BUTTON = "89.5:82.7"

Global const $POS_DUNGEON_ADENA_ENTER_BUTTON = "77.9:89.6"
Global const $POS_DUNGEON_DAILY_ENTER_BUTTON = "80.3:82.3"

Global const $POS_OMAN_DISSIPATION_BUTTON = "60.1:89.3"

Global const $POS_COMMON_FINISH_BUTTON = "70:91.1"

Global const $POS_JOYSTICK_LEFT = "1.3:79"
Global const $POS_JOYSTICK_RIGHT = "20.1:79"
Global const $POS_JOYSTICK_TOP = "11.3:67.5"
Global const $POS_JOYSTICK_BOTTOM = "11.3:93.1"
Global const $POS_JOYSTICK_CENTER = "11.5:79"

; ---------- Screen Check ------------
Global const $CHECK_SCREEN_ALERT_INFO = "XXX | 0x224872,0x1B406B,0x6A401A"	; blue
Global const $CHECK_SCREEN_ALERT_SCROLL_QUEST_START = "36.8:66.1 | 0x02C394A, 0x4D3C2F"	; dark blue (cancel button)
Global const $CHECK_SCREEN_ALERT_LOW_POWER = "53.7:73.8 | 0x224872, 0x1B406B, 0x6A401A"	; blue

Global const $CHECK_SCREEN_PORTALALERT = "52.5:73 | 0x224872, 0x1B406B, 0x6A401A"	; blue
Global const $CHECK_SCREEN_SCROLLQUEST_END = "42.8:85.8, 60.3:85.8, 63.3:85.8 66.3:85.8 | 0x224872, 0x1B406B, 0x6A401A | 8"	; blue
Global const $CHECK_SCREEN_MAINQUEST_EPISODE_END = "77.3:88.4, 88.4:88.4 | 0x224872, 0x1B406B, 0x6A401A | 8"	; blue

Global const $CHECK_SCREEN_PVP_END = "70:91.1 | 0x224872,0x1B406B,0x6A401A"	; blue
Global const $CHECK_SCREEN_PVP_START = "40:4.4 | 0xD00101,0xA51B06,0xDE0202"	; red
Global const $CHECK_SCREEN_PVP_USE_RED_DIA = "53.5:70.8 | 0x224872,0x1B406B,0x6A401A"	; blue
Global const $CHECK_SCREEN_PVP_NO_COUNT = "86.1:33.2 | 0x01F2028 | 8"	; darkgrey

Global const $CHECK_SCREEN_ADENA_NO_COUNT = "75:90.5 | 0x0393D43,0x3B4045 | 8"	; darkgrey
Global const $CHECK_SCREEN_ADENA_END = "69.1:88.6 | 0x224872,0x1B406B,0x6A401A"	; blue

Global const $CHECK_SCREEN_DAILY_NO_COUNT = "75:83.3  | 0x0393D43,0x3B4045 | 8"	; darkgrey

Global const $CHECK_SCREEN_AUTO_ATTCK_ACTIVATED = "65.4:91.3 | 0x0D5D5D5 | 8"	; white

Global const $CHECK_SCREEN_COMMON_DUNGEON_MAIN = "77.7:5 | 0xEDBE5B, 0xCEA14A, 0xA27C36, 0x4BA4D1, 0x3A84AB | 16"	; yellow

Global const $CHECK_SCREEN_SKIP = "84.7:97.1, 88.7:97.1 | 0x0000000"	; black

Global const $CHECK_SCREEN_ADVERTISING = "85:20.8 | 0x0A4A0A4 | 5"	; grey 'X'
