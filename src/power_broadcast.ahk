OnMessage(0x218, "power_broadcast")

; PBT_APMSUSPEND or PBT_APMSTANDBY? -> System will sleep
power_broadcast(wParam, lParam) {
    If (lParam == 0 && (wParam == 4 OR wParam == 5)) {
        soundset, mute
    }
}