#NoEnv
#NoTrayIcon
SetWorkingDir %A_ScriptDir%
SetKeyDelay, -1, -1
SetTitleMatchMode 2
DetectHiddenWindows On
Thread, NoTimers, false

#include src\prototype.ahk

OnMessage(0x6666, "ToOn")
OnMessage(0x6667, "ToOff")

global running := false

ToOn(wParam, lParam, msg) {
    PostMessage, 0x5555,,,, main.ahk ahk_exe AutoHotkey.exe
    notify("✔")
    settimer, main_loop, -1
}

ToOff(wParam, lParam, msg) {
    PostMessage, 0x5556,,,, main.ahk ahk_exe AutoHotkey.exe
    input
    notify("❌")
}

global EXPANSIONS := {"q": "aa"
                     ,"x": "ii"
                     ,"w": "ee"}

global REPLACEMENTS := {"aa": "Āā"
                       ,"ii": "Īī"
                       ,"ee": "Ēē"
                       ,"uu": "Ūū"
                       ,"ch": "Čč"
                       ,"nj": "Ņņ"
                       ,"gj": "Ģģ"
                       ,"kj": "Ķķ"
                       ,"lj": "Ļļ"
                       ,"zh": "Žž"
                       ,"sh": "Šš"
                       ,"oo": "Ōō"}

global EXCEPTIONS := ["paau"     ;paaudze,
    ,"saau"                      ;saaudze
    ,"saasi"                     ;saasinats
    ,"paaa:paā"                  ;paātrinat
    ,"saaa:saā"                  ;saāķēt

    ,"autoo"
    ,"koop"
    ,"zoo"
    ,"izoo"
    ,"koor"
    ,"mikroo"
    
    ,"vakuu"
    
    ,"iee"                       ;ieeja, ieelpot
    ,"nepiee"                    ;nepieejams
    ,"pieej"                     ;pieeja
    ,"reeva"                     ;reevakuācija
    ,"nees"                      ;neesošs
    ,"neee:neē"                  ;neēd, neērts
    ,"deesk"                     ;deeskalacija
    ,"neebr"                     ;neebrejs
    ,"neefe"                     ;neefektivs
    ,"neekr"                     ;neekranēts
    ,"neela"                     ;neelastigs
    ,"neele"                     ;neelegants
    ,"neeti"                     ;neetilēts
    ,"reent"                     ;reenterabla 
    ,"neelp"                     ;neelpoju
    ,"neeks"                     ;neeksistēt

    ,"shola"                     ;sholastika
    ,"shemat"                    ;shematisks
    ,"sheem:shēm:1"                ;shema 
    ,"disha"                     ;rmonija 

    ,"aizsargj"

    ,"anjon"                     ;s
    ,"kanjon"                    ;s
    ,"inj"                       ;ekcija / injicet 
    ,"jaunjel"                   ;gava
    ,"kompanjo"                  ;ns
    ,"konjak"                    ;s
    ,"konju"                     ;nktura
    ,"senjo"                     ;rs
    ,"shampinj:šampinj:1"          ; slikti ((( 
    
    ,"smalkj"                    ;utigs
    
    ,"barelj"                    ;efs
    ,"bataljo"                   ;ns
    ,"biljar"                    ;ds
    ,"briljant"                  ;s
    ,"buljon"                    ;s
    ,"dzhulj:Džulj:1"            ;
    ,"emalj"                     ;a
    ,"giljotin"                  ;a
    ,"gondolj"
    ,"kvadrilj"
    ,"miljon"
    ,"medaljo"
    ,"multimilj"
    ,"paviljo"
    ,"reljef"
    ,"triljon"
    ,"viljam"]

class _Exception {
    __new(string) {
        arr := strsplit(string, ":")
        this.ex := arr[1]
        this.sub := arr[2] ? arr[2] : arr[1]
        this.sub_t := format("{:T}", this.sub)
        this.len := strlen(this.ex)
        this.rem := this.len - 1
        if (arr[3])
            this.rem := this.rem - arr[3]
    }

    sub_adjusted(c) {
        if c is lower
            return % this.sub
        else
            return % this.sub_t
    }
}

for idx, val in EXCEPTIONS {
    EXCEPTIONS[idx] := new _Exception(val)
}

;#####################################################################

global READY := 2
global SKIP := 5
global status := READY
global last_input := "123456789-"

input_append(c) {
    last_input := SubStr(last_input, StrLen(c) + 1) . c
}

input_break() {
    input_append("-")
}

backspace_and_send(to_remove, text) {
    send % "{backspace " . to_remove . "}" . text
}

process(c) {
    last_two_letters := substr(last_input, -1)
    replacement := REPLACEMENTS[last_two_letters]


    if (status == READY && replacement) {
        replacement := replacement[last_two_letters.is_lower_at(1) ? 2 : 1]
        backspace_and_send(3 - strlen(c), replacement)
        status := SKIP
    } else {
        status := READY
    }


    ; find the first exception that the input ends with, make sure the character before it is not alpha,
    ; adjust substutution to the case of the first letter of input, and replace
    for idx, e in EXCEPTIONS {
        if (!last_input.is_alpha_at(-e.len) && last_input.ends_with_i(e.ex)) {
            sub := e.sub_adjusted(last_input[-e.len + 1])
            backspace_and_send(e.rem, sub)
            break
        }
    }

}

return

;##################################################################################################

main_loop:
Loop {
    Input, c, V L1 C, {Backspace}{Rbutton}{Lbutton}{LControl}{RControl}{LAlt}{RAlt}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
    if (ErrorLevel == "NewInput") {
        input_break()
        status := READY
        break
    } else if (SubStr(ErrorLevel, 1, 6) == "EndKey" && InStr("Backspace Left Right Up Down Home End PgUp PgDn Del", SubStr(ErrorLevel, 8))) {
        input_break()
        status := READY
    } else if (ErrorLevel == "Max") {
        expansion := EXPANSIONS[c]
        if (expansion) {
            c := expansion
            status := READY
        }
        input_append(c)
        process(c)
    }
}
return

notify(text) {
    color := text == "✔" ? "66aa66" : "777777"
    Progress, zh0 fs50 B C11 CW%color% CTFFFFFF W100 H100, %text%,,,Consolas
    settimer, notify_off, -500
}

notify_off:
    progress, off
return