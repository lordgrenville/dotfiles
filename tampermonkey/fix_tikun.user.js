// ==UserScript==
// @name         Tikun
// @namespace    http://tampermonkey.net/
// @version      0.0.1
// @description  Set font and column style for leining. Disable the trop
// @author       Josh Friedlander
// @match        https://tikunkorim.co.il/*
// @grant        none
// ==/UserScript==

(function() {

    'use strict';

    // Two column view. This is set by react components I didn't know how to change nicely so I just set localStorage, then reload the page
    var a = JSON.parse(localStorage.getItem("persist:root"));
    var b = JSON.parse(a.tikun);
    b.toraPageColumnsCount = 2;
    a.tikun = JSON.stringify(b);
    localStorage.setItem("persist:root", JSON.stringify(a));

    // Disable all events related to clicking on words which would bring up the audio
    // Have to watch to make sure the words have actually loaded though
    (new MutationObserver(check)).observe(document, {childList: true, subtree: true});

    function check(changes, observer) {
        if(document.querySelector(".word")) {
            observer.disconnect();

            // Set the classier looking font
            document.documentElement.style.setProperty("--tora-font-family", '"Tzlotana"');
            document.documentElement.style.setProperty("--tora-font-feature-settings", '"cv18"');
            const words = document.getElementsByClassName('word');
            for (let item of words) {
                onLongPress(item);

            }

        }
    }

    const words = document.getElementsByClassName('word');
    for (let item of words) {
        onLongPress(item);
    }

    function onLongPress(node) {
        node.ontouchstart = nullEvent;
        node.ontouchend = nullEvent;
        node.ontouchcancel = nullEvent;
        node.ontouchmove = nullEvent;
        node.oncontextmenu = nullEvent;
    }

    function nullEvent(event) {
        var e = event || window.event;
        e.preventDefault && e.preventDefault();
        e.stopPropagation && e.stopPropagation();
        e.cancelBubble = true;
        e.returnValue = false;
        return false;

    }
})();
