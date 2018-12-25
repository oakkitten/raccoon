(function () {
    match = /^(.*) \[([1234])\]$/.exec(document.title);
    console.log(match);
    [title, i] = match ? [match[1], match[2]] : [document.title, "3"]

    let a = document.activeElement;
    let bodyFocused = document.hasFocus() && a.tagName != "INPUT" && a.tagName != "TEXTAREA" && a.contentEditable != "true";

    if (bodyFocused) i = (i == "1") ? "3" : "1";
    else             i = (i == "2") ? "4" : "2";

    document.title = title + " [" + i + "]"
})();