#IfWinActive Photos ahk_class ApplicationFrameWindow
    .::send, ^{+}
    ,::send, ^-
    /::send, ^0

    a::send, {left}
    d::send, {right}
    w::send, {up}
    s::send, {down}
    q::send, ^{-}
    e::send, ^{+}
    f::send, ^0
#IfWinActive
