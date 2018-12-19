class Foo {
    enabled := false
    __new() {
        this.enabled := true
    }

    switch() {
        this.enabled := !this.enabled
    }
}

faa := new Foo()

MsgBox % faa.enabled

faa.switch()

MsgBox % faa.enabled