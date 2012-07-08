// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require pagedown/Markdown.Sanitizer.js
//= require pagedown/Markdown.Converter.js
//= require pagedown/Markdown.Editor.js
//= require_tree .

/* 0 = no request in progress
 * 1 = pre-request effect
 * 2 = pre-request effect completed
 * 3 = post-request effect
 */

(function () {
var ajaxLoadingState = 0;
var fadeTime = 150;
var sourceUrl;

/**
 * @brief takes a reference to an array of scripts to load (in order)
 * and executes them.
 */
function chainLoadScripts (arr) {
  var scriptUrl = arr.shift();
  if (!!scriptUrl) {
    $.ajax({
        url: scriptUrl
      , success: function () { chainLoadScripts(arr); }
    });
  }
}

function pullScripts(text) {
  var url;
  var scripts = $("script", text).get();
  var scriptUrls = [];

  // populate array of script urls to load
  for (var i in scripts) {
    // only load our own script type
    if(scripts[i].type === "text/x-pyropus-js") {
      url = scripts[i].getAttribute("src") || scripts[i].getAttribute("href");
      url = url.split("?")[0];
      scriptUrls.push(url);
      console.log("found one!", scriptUrls[scriptUrls.length - 1]);
    }
  }

  chainLoadScripts(scriptUrls);
}

function retrievePage(ev, e) {

  // get the url from the link or form
  sourceUrl = $(this).context.href || $(this).context.action;
  pullScripts(e.responseText);
  var dom = $(e.responseText);

  // replace the content and header
  $("#menubar").html($("#menubar", dom).html());
  $("#content").html($("#content", dom).html());
  $("#page_title").html($("#page_title", dom).html());
  $("#content").fadeIn(fadeTime);

  var errors = $("#alert", dom).html();
  if (errors)
    Pyropus.error(errors);

  window.history.pushState(null, "Pyropus", sourceUrl);

  // this is the main hook for "Things"
  try {
    document.bootstrap();
  } catch (e) {}
}

function ajaxLoading(ev, e) {
  ajaxLoadingState = 1;

  $("#notice").fadeOut();
  $("#alert").fadeOut();

  $("#content").fadeOut(fadeTime, function() {
    ajaxLoadingState = 2;
  });
}

function loginRevealHandler () {
  if ($(this).hasClass("initial")) {
    $("#nav_login input").show();
    $("#username-text").focus();
    $("#login-button").toggleClass('initial');
    return false;
  }
  $("#login-button").toggleClass('initial');
  return true;
};

$(window).ready(function () {

  // ajax fetchers
  $(document).on("ajax:complete", "[data-remote]=true", retrievePage);
  $(document).on("ajax:before", "[data-remote]=true", ajaxLoading);

  // login button handler
  $(document).on("click", "#login-button", loginRevealHandler);

  pullScripts($(document).html());
});

})();

var Pyropus = (function () {
  var MESSAGE = 0
    , NOTICE = 1
    , ERROR = 2

  var messageTimeouts = [];
  var displayTime = 15000;

  function error (str) {
    clearTimeout(messageTimeouts[ERROR]);
    $("#alert").html(str);
    $("#alert").fadeIn();
    $("#alert").click(function () {
      $(this).fadeOut();
    });
    messageTimeouts[ERROR] = setTimeout(function () {
      $("#alert").fadeOut();
    }, displayTime);
  }

  function notice (str) {
    clearTimeout(messageTimeouts[NOTICE]);
    $("#notice").html(str);
    $("#notice").fadeIn();
    $("#notice").click(function () {
      $(this).fadeOut();
    });
    messageTimeouts[NOTICE] = setTimeout(function () {
      $("#notice").fadeOut();
    }, displayTime);
  }

  $(document).ajaxError(function (ev, xhr, ajaxSettings, err) {
    error("An error has occured:</br><pre>" + err.toString() + "</pre>");
  });

  /* Add css for js managed things */
  $(document).ready(function () {
    var $jsStyle = $("style[type='pyropus/embeddedcss']");
    $jsStyle[0].type = "text/css";
    $("head").append($jsStyle[0]);
  });

  return {
    error: error,
    notice: notice
  };
})();
