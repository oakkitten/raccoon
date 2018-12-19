(function () {
    if (!document.hasFocus())
        return;
    let a = document.activeElement;
    if (a.tagName == "INPUT" || a.tagName == "TEXTAREA" || a.contentEditable == "true") {
        document.activeElement.blur();
        return;
    }
    var inputs = document.getElementsByTagName('input');
    for (var i = 0; i < inputs.length; i++) {
        e = inputs[i];
        if (!e.readonly 
            && e.type != "hidden"
            && !e.disabled 
            && e.style.display != 'none') {
            e.focus();
            return;
        }
    }
})();