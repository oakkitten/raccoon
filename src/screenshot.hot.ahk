; minicap must be on the path

global _SCREENSHOT_PATH
global _SCREENSHOT_URL
global _screenshot_last_name

_screenshot_init() {
    _SCREENSHOT_PATH = %C_HTML_FOLDER%s\
    _SCREENSHOT_URL = https://%C_WEBSITE%/s/
    _screenshot_last_name := "fn2387rghi2376"
    Menu, tray, add
    Menu, tray, add, %_screenshot_last_name%, _screenshot_copy
    Menu, tray, add, View, _screenshot_view
    Menu, tray, add, Edit, _screenshot_edit
}

_screenshot_take(target) {
    if (!_screenshot_last_name)
        _screenshot_init()
    name := get_random_string(10)
    Menu, tray, rename, %_screenshot_last_name%, %name%
    _screenshot_last_name := name

    RunWait, minicap -save "%_SCREENSHOT_PATH%%name%.png" -customdate "$d$m$y-$H$M$S" -capture%target% -exit,, hide
    clipboard := _SCREENSHOT_URL . name
}

_screenshot_copy:
    clipboard := _SCREENSHOT_URL . _screenshot_last_name
Return

_screenshot_view:
        Run % _SCREENSHOT_PATH . _screenshot_last_name . ".png"
Return

_screenshot_edit: 
        Run % "mspaint " . _SCREENSHOT_PATH . _screenshot_last_name . ".png"
Return

#v::_screenshot_take("desktop")
#b::_screenshot_take("objselect")
#n::_screenshot_take("regselect")