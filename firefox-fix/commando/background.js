
// * toggle-pin-tab is obvious
//
// * focus-unfocus-first-input focuses or unfocuses (blurs) the first input field 
//   on the page, allowing you to either type in your search, or scroll
//   only works if the page is focused
//
// * check-input-status appends " [a]" to the title of the page, where a is odd if
//   the page IS focused but IS NOT accepting text input, even otherwise. the title
//   is guaranteed to change if the permissions are met

chrome.commands.onCommand.addListener(function(action) {
    console.log("onCommand event received for message: ", action);
    ({
        "toggle-pin-tab": togglePinTab,
        "focus-unfocus-first-input": call.bind(null, "focus-unfocus-first-input.js"),
        "check-input-status": call.bind(null, "check-input-status.js")
    })[action]();
});

function togglePinTab() {
    chrome.tabs.query({currentWindow: true, active: true,}, function(foundTabs) {
        var currentTabId = foundTabs[0].id
        chrome.tabs.get(currentTabId, function(currentTab) {
            const toggledValue = !currentTab.pinned;
            chrome.tabs.update(currentTabId, {pinned: toggledValue});
        });
    });
}

function focusActiveTab() {

}

function call(f) {
    browser.tabs.executeScript({"file": f});
}