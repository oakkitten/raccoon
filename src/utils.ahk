; check if object such as array contains an element
hasval(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

; allow string[idx]
; 
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