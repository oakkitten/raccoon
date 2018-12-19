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