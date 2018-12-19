OnClipboardChange:
    if WinActive("ahk_exe anki.exe")
        return

    if (A_EventInfo = 2) {
        notify("non-text data", 2000, ,"308A8A")
    } else {
        if (clipboard.starts_with_i("""" . C_HTML_FOLDER))
            clipboard := replace_path_with_url()
        notify(clipboard, 2000, ,"8A3030", false)
    }
return

replace_path_with_url() {
    old_file := SubStr(clipboard, 2, -1)
    new_file := StrReplace(old_file, " ", "_")
    FileMove, %old_file%, %new_file%
    if (ErrorLevel <> 0) {
        SoundPlay, C:\Windows\Media\Windows Hardware Fail.wav
        notify("FILE ALREADY EXISTS", 1000, true, "FF6666")
    }
    out := "https://" . C_WEBSITE . "/" . SubStr(new_file, 9)
    StringReplace, out, out, `\, `/, All
    return out
}
