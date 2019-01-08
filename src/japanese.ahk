#include src\traditional_simplified_char_map.ahk

class _Japanese {
    big5_encode(text) {
        static big5 := "cp950"
        length := StrPut(text, big5)
        VarSetCapacity(bin, length)
        length2 := StrPut(text, &bin, big5)
        Loop, % length - 1 ; -1 to exclude null byte at end
            out .= Format("%{:02X}", NumGet(Bin, A_Index-1, "UChar"))
        return out
    }

    copy_open_ebwin_paste() {
        if (this.anki_copy())
            this.open_ebwin_paste()
    }

    open_ebwin_paste() {
        IfWinExist, ahk_class EB_POCKET
        {
            WinActivate
            WinWaitActive, ahk_class EB_POCKET, , 3
            if (!ErrorLevel) {
                ; esc, ctrl-v, enter
                Send, {esc}^{vk56sc02F}{Enter}
            } else {
                notify("window didn't activate")
            }
        } else {
            notify("window does not exist")
        }
    }

    open_browser() {
        Send, b
        WinWaitActive, Browser, , 1
        success := !ErrorLevel
        if (sucess)
            WinRestore
        return success
    }

    open_browser_kanji_paste() {
        if (this.open_browser())
            Send, ^{vk46sc021}Kanji:*^{vk56sc02F}*{Enter}{Left}^+{Left}
    }

    open_browser_expression_paste() {
        if (this.open_browser())
            Send, ^{vk46sc021}Expression:*^{vk56sc02F}* -card:Production{Enter}^{Left 5}^+{Left}
    }

    open_browser_paste() {
        if (this.open_browser())
            Send, ^{vk46sc021}^{vk56sc02F} -card:Production{Enter}^{Left 5}^+{Left}
    }

    anki_copy() {
        clipboard =
        Send, ^{vk43sc02E}
        ClipWait, 1, 1
        sleep, 120
        if (ErrorLevel) {
            notify("clipboard empty")
            return false
        }
        return true
    }

    open_zhongwen() {
        global _Japanese_simplified, _Japanese_traditional
        kanji = %clipboard%
        if (StrLen(kanji) != 1) {
            notify("too long ["  Clipboard  "]")
            return
        }
        hanzi := translate(kanji, _Japanese_simplified, _Japanese_traditional)
        code := this.big5_encode(hanzi)
        if (code = "%3f" || code = "") {
            notify("can't into big5")
            return
        }
        Run, % "http://zhongwen.com/cgi-bin/zipux.cgi?=" code
    }

    ; https://qiita.com/nosu/items/b2101318172f373d14a6
    ime_get(WinTitle="A") {
        return DllCall("SendMessage", UInt, this.get_active_ime_hwnd()
              , UInt, 0x0283  ;Message : WM_IME_CONTROL
              ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
              ,  Int, 0)      ;lParam  : 0
    }

    ime_set(value, WinTitle="A") {
        return DllCall("SendMessage", UInt, this.get_active_ime_hwnd()
              , UInt, 0x0283  ;Message : WM_IME_CONTROL
              ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
              ,  Int, value)  ;lParam  : 0 or 1
    }

    get_active_hwnd(title:="A") {
        ControlGet, hwnd, HWND,,, %title%
        if (WinActive(title)) {
            ptr_size := !A_PtrSize ? 4 : A_PtrSize
            info_size := 4 + 4 + (ptr_size * 6) + 16
            VarSetCapacity(info, info_size, 0)
            NumPut(info_size, info,  0, "UInt")
            hwnd := DllCall("GetGUIThreadInfo", Uint, 0, Uint, &info)
                     ? NumGet(info, 8 + ptr_size, "UInt") : hwnd
        }
        return % hwnd
    }

    get_active_ime_hwnd(title:="A") {
        return % DllCall("imm32\ImmGetDefaultIMEWnd", Uint, this.get_active_hwnd(title))
    }
}

japanese := new _Japanese()

settimer, _Japanese_check, 200