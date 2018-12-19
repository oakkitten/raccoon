^f9::_pastebin_paste()

_pastebin_paste() {
    progress, off
    InputBox, paste_file, File name to create,%clipboard%,,,,,,,60,% get_random_string(10)
    If (ErrorLevel != 0 || strlen(paste_file) < 3)
        Return

    name := C_HTML_FOLDER . "p\" . ((InStr(paste_file, ".")) ? paste_file : (paste_file . ".txt"))
    if (FileExist(name)) {
        msgbox, file exists
        Return
    }
    FileAppend, %clipboard%, %name%, utf-8  
    Clipboard = https://%C_WEBSITE%/p/%paste_file%
}