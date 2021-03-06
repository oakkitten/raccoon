hasval(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

; ########################################################## get current input language

get_lang() {
    SetFormat, Integer, H
    WinGet, WinID,, A
    ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
    InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
    return, InputLocaleID
}

set_lang(layout) {
    PostMessage, 0x50, 0, %layout%,, A
}

; ########################################################## get random string

get_random_string(l = 16) {
    s = a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9
    s := s . s . s . s . s . s
    Sort, s, Random D,
    s := RegExReplace(s, ",")
    s := substr(s, 1, l)
    Return s
}

; ########################################################## translate

translate(string, from, to) {
    out := ""
    loop, parse, string
    {
        stringgetpos, pos, from, %A_LoopField%
        out := out . (pos == -1 ? A_LoopField : substr(to, pos + 1, 1))
    }
    return % out
}

; ########################################################## notify

notify(text, time:=1000, blocking:=false, color:="005588", center:=true) {
    center := center ? "1" : "0"
    progress, zh0 fs10 B C%center%0 CW%color% CTFFFFFF, %text%,,,Consolas
    if (blocking) {
        sleep %time%
        progress, off
    } else {
        settimer, _progress_off, -%time%
    }
}

_progress_off:
    progress, off
return