class _Japanese {
    splash(text) {
        notify(text)
    }

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
                ; ctrl-shift-f, ctrl-v, enter
                Send, ^+{vk46sc021}^{vk56sc02F}{Enter}
            } else {
                this.splash("window didn't activate")
            }
        } else {
            this.splash("window does not exist")
        }
    }

    _open_browser() {
        Send, b
        WinWaitActive, Browser, , 1
        success := !ErrorLevel
        if (sucess)
            WinRestore
        return success
    }

    open_browser_kanji_paste() {
        if (this._open_browser())
            Send, ^{vk46sc021}Kanji:*^{vk56sc02F}*{Enter}{Left}^+{Left}
    }

    open_browser_expression_paste() {
        if (this._open_browser())
            Send, ^{vk46sc021}Expression:*^{vk56sc02F}* -card:Production{Enter}^{Left 5}^+{Left}
    }

    open_browser_paste() {
        if (this._open_browser())
            Send, ^{vk46sc021}^{vk56sc02F} -card:Production{Enter}^{Left 5}^+{Left}
    }

    anki_copy() {
        clipboard =
        Send, ^{vk43sc02E}
        ClipWait, 1, 1
        sleep, 120
        if (ErrorLevel) {
            this.splash("clipboard empty")
            return false
        }
        return true
    }

    open_zhongwen() {
        trimmed = %clipboard%
        if (StrLen(trimmed) != 1) {
            this.splash("too long ["  Clipboard  "]")
            return
        }
        code := this.big5_encode(trimmed)
        if (code = "%3f" || code = "") {
            this.splash("can't into big5")
            return
        }
        Run, % "http://zhongwen.com/cgi-bin/zipux.cgi?=" code
    }
}

japanese := new _Japanese()