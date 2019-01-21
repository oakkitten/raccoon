; ############################### ANKI

; z     copy → browser (expression)
; f1, x copy → paste in ebwin
; c     copy → browser (kanji)
; v     copy → zhongwen

; f2    browser → kanji 1
; f3    browser → kanji 2
; f4    browser → expression 

; f5    ebwin → kanji 1
; f6    ebwin → kanji 2
; f6    ebwin → expression

; ############################### ANKI browser

; f1    copy → paste in ebwin
; f2-7  minimize

; ############################### some other apps

; f1    minimize

; ###############################

; c = vk43sc02E
; v = vk56sc02F
; a = vk41sc01e
; f = vk46sc021

#IfWinActive, ^Anki - sq$
    z::
        if (japanese.anki_copy())
            japanese.open_browser_expression_paste()
    return

    c::
        if (japanese.anki_copy())
            japanese.open_browser_kanji_paste()
    return

    f1::
    x::
        japanese.copy_open_ebwin_paste()
    return

    f2::
    f3::
    f4::
        browser := true
    f5::
    f6::
    f7::
        clipboard =
        send % "{" . (browser ? A_ThisHotkey : ("f" + (SubStr(A_ThisHotkey, 2, 1) - 3))) . "}"
        ClipWait, 1,
        Sleep, 120

        if (!ErrorLevel) {
            if (browser) {
                if (A_ThisHotkey = "f4")
                    japanese.open_browser_paste()
                else
                    japanese.open_browser_kanji_paste()
            }
            else 
                japanese.open_ebwin_paste()
        } else {
            japanese.splash("clipboard empty")
        }
        browser := false
    return

    v::
        if (japanese.anki_copy())
            japanese.open_zhongwen()
    return
#IfWinActive

#IfWinActive, ahk_class QWidget ahk_exe anki.exe
    f1::
        japanese.copy_open_ebwin_paste()
    return
    f2::
    f3::
    f4::
    f5::
    f6::
    f7::
        Send, {esc}
    return
#IfWinActive

;############################################################################ Putty

#IfWinActive, ahk_class PuTTY
    f1::
        if (A_Priorkey == "LShift") {
            japanese.open_ebwin_paste()
        } else {
            _putty_open_url(SubStr(A_ThisHotkey, 2))
        }
    return
#IfWinActive

;############################################################################ Firefox

#IfWinActive, ahk_class MozillaWindowClass
    f1::WinMinimize

    f2::
        japanese.copy_open_ebwin_paste()
    return
#IfWinActive

;############################################################################ etc

#IfWinActive, ahk_class EB_POCKET
    f1::
    f2::
    f3::
    f4::
    f5::
    f6::
    f7::
#IfWinActive, ahk_class {E7076D1C-A7BF-4f39-B771-BCBE88F2A2A8}
    f1::
#IfWinActive, ahk_class CabinetWClass
    f1::
#IfWinActive, ahk_class Qt5QWindowIcon
    f1::
        WinMinimize
    return
#IfWinActive

;############################################################################ djvu, pdf

#IfWinActive, ahk_exe WinDjView.exe
#IfWinActive, ahk_class DSUI:PDFXCViewer
    a::Send, {up 6}
    w::send, {up}
    s::send, {down}
    d::send, {down 6}
#IfWinActive

_Japanese_check:
    if (WinActive("^Anki - sq$")) {
        if (japanese.ime_get())
            japanese.ime_set(0)
    }
return
