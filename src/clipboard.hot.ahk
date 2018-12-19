OnClipboardChange:
    if WinActive("ahk_exe anki.exe")
        return

    if (A_EventInfo = 2) {
        Progress, zh0 fs10 B C00 CW308A8A CTFFFFFF, non-text data,,,Consolas
    } else {
        if (clipboard.starts_with_i("""" . C_HTML_FOLDER))
            clipboard := replace_path_with_url()
        Progress, zh0 fs10 B C00 CW8A3030 CTFFFFFF, %clipboard%,,,Consolas
    }
    settimer, _clipboard_splash_off, -2000
return

replace_path_with_url() {
    old_file := SubStr(clipboard, 2, -1)
    new_file := StrReplace(old_file, " ", "_")
    FileMove, %old_file%, %new_file%
    if (ErrorLevel <> 0) {
        SoundPlay, C:\Windows\Media\Windows Hardware Fail.wav
        Progress, zh0 fs10 B C00 CWFF6666 CTFFFFFF, FILE ALREADY EXISTS,,,Consolas
        sleep, 1000
    }
    out := "https://" . C_WEBSITE . "/" . SubStr(new_file, 9)
    StringReplace, out, out, `\, `/, All
    return out
}

_clipboard_splash_off:
    progress, off
return