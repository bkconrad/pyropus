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

(function () {
var fadeTime = 150;
var sourceUrl;

function pullScripts(text) {
  var frag = document.createDocumentFragment()
    , div = document.createElement('div')
    , scriptElements
    , i
    ;

  // This is roughly how jQuery finds the scripts when cleaning text
  frag.appendChild(div);
  div.innerHTML = text;

  // we only want scripts in the content div, but HTMLElements don't have
  // getElementById(), so we use a class name instead
  // TODO: this assumes that there is something with the class 'content'
  scriptElements = div.getElementsByClassName('content')[0]
                      .getElementsByTagName('script');

  $('head').append(scriptElements);
}

function retrievePage(event, xhr, settings) {

  // get the url from the link or form
  sourceUrl = $(this).context.href || $(this).context.action;

  var $dom = $(xhr.responseText);
  // replace the content and header
  $("#menubar").html($("#menubar", $dom).html());
  $("#content").html($("#content", $dom).html());
  $("#page_title").html($("#page_title", $dom).html());
  $("#content").fadeIn(fadeTime);

  pullScripts(xhr.responseText);
  Pyropus.runStartupQueue();

  // TODO: What about notice and message?
  var errors = $("#alert", $dom).html();
  if (errors)
    Pyropus.error(errors);

  window.history.pushState(null, "Pyropus", sourceUrl);
}

function ajaxLoading(ev, xhr, settings) {
  Pyropus.runTeardownQueue();

  $("#notice").fadeOut();
  $("#alert").fadeOut();

  $("#content").fadeOut(fadeTime);
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

$(window).load(function () {
  // ajax fetchers
  $(document).on("ajax:complete", "[data-remote]=true", retrievePage);
  $(document).on("ajax:beforeSend", "[data-remote]=true", ajaxLoading);

  // login button handler
  $(document).on("click", "#login-button", loginRevealHandler);
});

})();

var Pyropus = (function () {
  var MESSAGE = 0
    , NOTICE = 1
    , ERROR = 2

  var execQueue = [];
  var exitExecQueue = [];
  var messageTimeouts = [];
  var displayTime = 15000;

  function startup (fn) {
    if (typeof fn === 'function') {
      if (document.readyState === 'complete') {
        execQueue.push(fn);
      } else {
        $(document).ready(fn);
      }
    }
  }

  function runStartupQueue () {
    var i;
    for (i = 0; i < execQueue.length; i++) {
      execQueue[i]();
    }
    execQueue = [];
  }

  function teardown (fn) {
    if (typeof fn === 'function') {
      exitExecQueue.push(fn);
    }
  }

  function runTeardownQueue () {
    var i;
    for (i = 0; i < exitExecQueue.length; i++) {
      exitExecQueue[i]();
    }
    exitExecQueue = [];
  }

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
    var $jsStyle = $("style[type='pyropus/embeddedcss']").get();
    if ($jsStyle.length > 0) {
      $jsStyle[0].type = "text/css";
      $("head").append($jsStyle[0]);
    }
  });

  return {
    startup: startup,
    teardown: teardown,
    runTeardownQueue: runTeardownQueue,
    runStartupQueue: runStartupQueue,
    error: error,
    notice: notice
  };
})();
