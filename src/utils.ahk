hasval(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

; ########################################################## string prototype tools

class Strings {
    static init := ("".base.base := Strings)
    
    __Get(pos) {
        return SubStr(this, pos, 1)
    }

    is_lower_at(pos) {
        c := this[pos]
        if c is lower
            return % true
        else
            return % false
    }

    is_alpha_at(pos) {
        c := this[pos]
        if c is alpha
            return % true
        else
            return % false
    }

    starts_with_i(str) {
        return % substr(this, 1, strlen(str)) = str
    }

    ends_with_i(str) {
        return % substr(this, -strlen(str) + 1) = str
    }
}

; ########################################################## get current input language

get_lang() {
    SetFormat, Integer, H
    WinGet, WinID,, A
    ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
    InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
    return, InputLocaleID
}