OnMessage(0x5555, "_Latvian_on")
OnMessage(0x5556, "_Latvian_off")

class _Latvian {
    static EXCLUDED_CLASSES := [
        ,"TaskSwitcherWnd"
        ,"Shell_TrayWnd"
        ,"DV2ControlHost"
        ,"Net UI Tool Window"]

    __new() {
        Menu, Tray, Icon, res\latvian_off.ico, 1, 0
        Menu, Tray, Icon

        WinKill latvianloop\.ahk - AutoHotkey
        Run, src\latvianloop.ahk
        WinWait, latvianloop.ahk

        this.latvianloop := WinExist("latvianloop.ahk")
        this.enabled := false
        this.win := []

        settimer, _Latvian_check, 100
    }

    switch() {
        WinGet, cw, ID, A
        this.win[cw] := !this.win[cw]
    }

    check() {
        WinGet, cw, ID, A
        if (cw == "" || !!this.win[cw] == !!this.enabled) 
            return

        WinGetClass, class, ahk_id %cw%
        if (hasval(EXCLUDED_CLASSES, class))
            return

        this.enabled := !this.enabled
        message := this.enabled ? 0x6666 : 0x6667
        PostMessage, %message%,,,,% "ahk_id " . this.latvianloop
    }
}

_Latvian_on(wParam, lParam, msg) {
    Menu, Tray, Icon, res\latvian_on.ico, 1, 0
}

_Latvian_off(wParam, lParam, msg) {
    Menu, Tray, Icon, res\latvian_off.ico, 1, 0
}

latvian := new _Latvian()