!function (t) { var e = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {}; window.selfHostTagConfig = e; var s = new XMLHttpRequest; s.onreadystatechange = function () { 4 == this.readyState && 200 == this.status && (window.selfHostTagConfig = JSON.parse(s.responseText)) }, s.open("GET", t, !1), s.send(); var a = Node.prototype.appendChild; Node.prototype.appendChild = function () { return arguments[0] = d(arguments[0]), a.apply(this, arguments) }; var o = Node.prototype.insertBefore; Node.prototype.insertBefore = function () { return arguments[0] = d(arguments[0]), o.apply(this, arguments) }; var n = Node.prototype.prepend; Node.prototype.prepend = function () { return arguments[0] = d(arguments[0]), n.apply(this, arguments) }; var d = function (t) { return "SCRIPT" === t.tagName && window.selfHostTagConfig[t.src] && (t.setAttribute("data-self-hosted", "true"), t.setAttribute("src", window.selfHostTagConfig[t.src])), t } }("https://self-hosted-tags-development.swishjam.com/key_a98d04d1bc85d257ce40/config.json",{"https://cdn.yottaa.com/rapid.rum.min.js":"https://self-hosted-tags-development.s3.us-east-1.amazonaws.com/key_a98d04d1bc85d257ce40/cdn_yottaa_com_rapid_rum_min_js_c8a1951930a9e055eb351823a08853cc_minified.js","https://www.thirdpartytag.com/script.js":"https://self-hosted-tags-development.s3.us-east-1.amazonaws.com/key_a98d04d1bc85d257ce40/www_thirdpartytag_com_script_js_b1aa76ad69ce5e62c0a8231704dbd9d7_original.js","https://cdn.segment.com/analytics.js/v1/4qYDwD8QrJuqCpqlIuN6waqj5BtfYZzu/analytics.min.js":"https://self-hosted-tags-development.s3.us-east-1.amazonaws.com/key_a98d04d1bc85d257ce40/cdn_segment_com_analytics_js_v1_4qYDwD8QrJuqCpqlIuN6waqj5BtfYZzu_analytics_min_js_ea66e96b1c5f46e93f6b69ab6160a500_minified.js"});