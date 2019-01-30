#InstallKeybdHook
#UseHook
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 100
#NoTrayIcon

DetectHiddenWindows On
SetWorkingDir %A_ScriptDir%
SetKeyDelay, -1, -1
SetTitleMatchMode RegEx
SetTitleMatchMode Fast
CoordMode, ToolTip, Screen
CoordMode, Caret, Screen

DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

#include src\prototype.ahk
#include src\hardcoded.ahk
#include src\secret.ahk
#include src\power_broadcast.ahk
#include src\latvian.ahk
#include src\japanese.ahk

return

^!+`::
    notify("reloading",,true)
    Reload
return

#include src\utils.hot.ahk
#include src\clipboard.hot.ahk
#include src\latvian.hot.ahk
#include src\japanese.hot.ahk
#include src\common.hot.ahk
#include src\key_fix.hot.ahk
#include src\firefox.hot.ahk
#include src\pastebin.hot.ahk
#include src\photos.hot.ahk
#include src\putty.hot.ahk
#include src\screenshot.hot.ahk
#include src\language_fix.hot.ahk