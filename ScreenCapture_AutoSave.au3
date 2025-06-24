#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <Date.au3>

Global $winW = 520, $winH = 240
Global $hGUI = GUICreate("定时屏幕截图", $winW, $winH, -1, -1, -1, $WS_EX_TOPMOST)
GUICtrlCreateLabel("定时自动屏幕截图", 20, 15, 300, 25)
GUICtrlCreateLabel("保存目录：", 20, 55, 70, 20)
Global $inpDir = GUICtrlCreateInput(@ScriptDir, 90, 55, 320, 20)
Global $btnBrowse = GUICtrlCreateButton("浏览", 420, 55, 60, 20)
GUICtrlCreateLabel("截图间隔(分钟)：", 20, 90, 100, 20)
Global $inpInterval = GUICtrlCreateInput("30", 140, 90, 60, 20)
Global $btnStart = GUICtrlCreateButton("开始", 60, 130, 100, 35)
Global $btnStop = GUICtrlCreateButton("停止", 180, 130, 100, 35)
Global $btnManual = GUICtrlCreateButton("手动截图", 300, 130, 100, 35)
Global $lblStatus = GUICtrlCreateLabel("状态：未启动", 20, 190, 340, 20)
GUICtrlCreateLabel("版权所有 © 灯火通明（济宁）网络有限公司", $winW - 260, $winH - 20, 260, 18)
GUISetState(@SW_SHOW, $hGUI)
WinSetOnTop($hGUI, "", 1)

Global $bRunning = False
Global $interval = 30
Global $saveDir = @ScriptDir
Global $nextCapture = TimerInit()

While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $btnBrowse
            Local $chosen = FileSelectFolder("选择截图保存目录", "", 1, $saveDir)
            If $chosen <> "" Then
                GUICtrlSetData($inpDir, $chosen)
                $saveDir = $chosen
            EndIf
        Case $btnStart
            $saveDir = GUICtrlRead($inpDir)
            $interval = Number(GUICtrlRead($inpInterval))
            If $interval < 1 Then $interval = 30
            If Not FileExists($saveDir) Then
                DirCreate($saveDir)
            EndIf
            $bRunning = True
            $nextCapture = TimerInit()
            GUICtrlSetData($lblStatus, "状态：运行中，每" & $interval & "分钟截图一次")
        Case $btnStop
            $bRunning = False
            GUICtrlSetData($lblStatus, "状态：已停止")
        Case $btnManual
    $saveDir = GUICtrlRead($inpDir)
    If Not FileExists($saveDir) Then
        DirCreate($saveDir)
    EndIf
    Local $now = @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC
    Local $filename = $saveDir & "\Screenshot_" & StringReplace($now, ":", "") & ".jpg"
    _ScreenCapture_Capture($filename)
    GUICtrlSetData($lblStatus, "手动截图成功：" & $filename)
    EndSwitch

    If $bRunning Then
        If TimerDiff($nextCapture) >= $interval * 60 * 1000 Then
            Local $now = @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC
            Local $filename = $saveDir & "\Screenshot_" & StringReplace($now, ":", "") & ".jpg"
            _ScreenCapture_Capture($filename)
            GUICtrlSetData($lblStatus, "已截图：" & $filename)
            $nextCapture = TimerInit()
        EndIf
    EndIf
    Sleep(50)
WEnd