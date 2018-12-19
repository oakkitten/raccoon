#InstallKeybdHook
#UseHook
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 100
;#NoTrayIcon

DetectHiddenWindows On
SetWorkingDir %A_ScriptDir%
SetKeyDelay, -1, -1
SetTitleMatchMode RegEx
SetTitleMatchMode Fast
CoordMode, ToolTip, Screen
CoordMode, Caret, Screen

DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

; global vars

; code

#include src\power_broadcast.ahk
#include src\utils.ahk
#include src\latvian.ahk

; hotkeys

^!+`::
    SplashTextOn, 70, -1, Reloading...,
    Sleep 500
    SplashTextOff
    Reload
return

#include src\latvian.hot.ahk
;#include src\photos.hot.ahk