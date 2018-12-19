; caps lock mapped to right ctrl
; short press on caps lock acts like esc

rctrl::
    Send, {rCtrl Down}
    _key_fix_ctrl_pressed_at := A_TickCount
return

rctrl Up::
    Send, {rCtrl Up}
    if (A_Priorkey == "RControl" && (A_TickCount - _key_fix_ctrl_pressed_at) < 300) {
        if (WinActive("ahk_exe bomi.exe"))
            send, {Enter}
        else
            send, {esc}
    }
return