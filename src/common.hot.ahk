; ########################################################## misc

:*:.ьу::/me

:*:.,.::._.
:*:.,,.::.__.
:*:.,,,.::.___.
:*:.,,,,.::.____.

:*:.shrug::¯\_(ツ)_/¯

:*?:---::—
$!'::send, ́
$!;::send, °

^+SPACE::
    Winset, Alwaysontop, , A
    WinGet, _common_style, ExStyle, A
    notify("always on top: " . (_common_style & 0x8 ? "on" : "off"))
return

; ########################################################## fb2k forwards

#z::send, ^!+{F5}
#x::send, ^!+{F6}
#q::send, ^!+{F7}
#w::^!+w
#a::send, ^!+{F8}

; ########################################################## idiotic smileys

^#`::Send {U+25D5}{U+203F}{U+203F}{U+25D5}
^#5::Send {U+25D5}{U+203F}{U+203F}{U+25D5}
^#1::Send {U+25E0}{U+203F}{U+203F}{U+25E0}
^#2::Send {U+25D2}{U+203F}{U+203F}{U+25D3}
^#3::Send {U+25E1}{U+203F}{U+203F}{U+25E1}
^#4::Send {U+25CF}{U+032E}{U+0020}{U+032E}{U+25CF}

; ########################################################## some movement

>+PgDn Up::send, {RShift Up}{End}
>+PgUp Up::send, {RShift Up}{Home}

; ########################################################## caps

^+F11::send, {Capslock}

; ########################################################## ctrl-w == ctrl-backspace

^w::send {Del}^{Backspace}

; ########################################################## quote

$!j::
$!k::
    send % _common_quote(A_ThisHotkey == "$!j")
return

_common_quote(which) {
    quotes := ["«", "»", "{bs}„", "{bs}“", "“", "”", "{bs}‘", "{bs}’"]
    offset := 1
    if (get_lang() != 0x4190419)
        offset += 4
    if (A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 500)
        offset += 2
    if (!which)
        offset += 1
    return quotes[offset]
}

; ########################################################## restart explorer

^!+1::Process, Close, explorer.exe