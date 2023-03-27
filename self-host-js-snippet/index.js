(function(configEndpoint, hostingConfig = {}) {
  window.selfHostTagConfig = hostingConfig;

  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      window.selfHostTagConfig = JSON.parse(xhttp.responseText);
    }
  };
  xhttp.open("GET", configEndpoint, false);
  xhttp.send();

  const ogAppendChild = Node.prototype.appendChild;
  Node.prototype.appendChild = function () {
    arguments[0] = _reMapScriptTagIfNecessary(arguments[0]);
    return ogAppendChild.apply(this, arguments);
  };

  const ogInsertBefore = Node.prototype.insertBefore;
  Node.prototype.insertBefore = function () {
    arguments[0] = _reMapScriptTagIfNecessary(arguments[0]);
    return ogInsertBefore.apply(this, arguments);
  };

  const ogPrepend = Node.prototype.prepend;
  Node.prototype.prepend = function () {
    arguments[0] = _reMapScriptTagIfNecessary(arguments[0]);
    return ogPrepend.apply(this, arguments);
  };

  const _reMapScriptTagIfNecessary = function(newNode) {
    if (newNode.tagName === 'SCRIPT' && window.selfHostTagConfig[newNode.src]) {
      newNode.setAttribute('data-self-hosted', 'true');
      newNode.setAttribute('src', window.selfHostTagConfig[newNode.src]);
    }
    return newNode;
  }
})('REPLACE_WITH_CONFIG_ENDPOINT', { "https://cdn.yottaa.com/rapid.rum.min.js": "https://self-hosted-tags-development.s3.us-east-1.amazonaws.com/key_a98d04d1bc85d257ce40/cdn_yottaa_com_rapid_rum_min_js_c8a1951930a9e055eb351823a08853cc_minified.js", "https://www.thirdpartytag.com/script.js": "https://self-hosted-tags-development.s3.us-east-1.amazonaws.com/key_a98d04d1bc85d257ce40/www_thirdpartytag_com_script_js_b1aa76ad69ce5e62c0a8231704dbd9d7_original.js", "https://cdn.segment.com/analytics.js/v1/4qYDwD8QrJuqCpqlIuN6waqj5BtfYZzu/analytics.min.js": "https://self-hosted-tags-development.s3.us-east-1.amazonaws.com/key_a98d04d1bc85d257ce40/cdn_segment_com_analytics_js_v1_4qYDwD8QrJuqCpqlIuN6waqj5BtfYZzu_analytics_min_js_ea66e96b1c5f46e93f6b69ab6160a500_minified.js" })