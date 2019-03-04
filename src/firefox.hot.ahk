; commando! must be loaded in firefox

#IfWinActive, ahk_class MozillaWindowClass
    ; #################################### pin tab

    ^j::send !{f1}

    ; #################################### movement

    ^w::send % _firefox_input() ? "{del}^{bs}" : "{up 2}"
    ^a::send % _firefox_input() ? "^a" : "{up 7}"

    ^w up::
    ~^a up::
        _firefox_status := 0
    return

    ^s::send {down 2}
    ^d::send {down 7}

    ^+a::send {home}
    ^+d::send {end}

    ; #################################### navigation & tabs

    ^q::send {Browser_Back}
    ^e::send {Browser_Forward}

    !c::send ^{tab}
    !z::send ^+{tab}
    !x::send ^w
    
    ; #################################### focus input field

    !Esc::send, !{f2}

    ; #################################### change icon for current window

    ^!l::_firefox_change_icon()
#IfWinActive


_firefox_input() {
    global _firefox_status
    if (!_firefox_status)
        _firefox_status := _firefox_get_input_status()
    return % _firefox_status == 2
}

_firefox_get_input_status() {
    WinGetTitle, old, A
    if (old == "Firefox Developer Edition" or old == "Firefox Nightly")
        return 2

    send, !{f3}
    Loop, 3 {
        sleep, 10
        WinGetTitle, new, A
        if (new != old) {
            RegExMatch(new, "\[(\d)\][ -]+Firefox(?: [A-z]+)*", i)
            return % i1 > 2 ? i1 - 2 : i1
        }
    }
    return 1
}

_firefox_change_icon() {
    notify("changing icon...")
    WinGet, ID, id, A
    hIcon := DllCall( "LoadImage", UInt,0, Str,"res\firefox.ico", UInt,1, UInt,32, UInt,32, UInt,0x10)
    SendMessage, 0x80, 0, hIcon ,, ahk_id %ID%  ; One affects Title bar and
    SendMessage, 0x80, 1, hIcon ,, ahk_id %ID%  ; the other the ALT+TAB menu
}