LAlt & LShift::language_fix_switch()

language_fix_switch() {
    LANG_EN_US = 0x4090409
    LANG_JA    = 0x4110411
    LANG_RU    = 0x4190419

    lang := get_lang()

    if (lang == LANG_RU) {
        set_lang(LANG_JA)
    } else if (lang == LANG_JA or lang == LANG_EN_US) {
        set_lang(LANG_RU)
    } else {
        send !{shift}
    }
}