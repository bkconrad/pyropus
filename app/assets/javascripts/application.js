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
//= require_tree .

/* 0 = no request in progress
 * 1 = pre-request effect
 * 2 = pre-request effect completed
 * 3 = post-request effect
 */

(function () {
var ajaxLoadingState = 0;
var fadeTime = 75
var sourceUrl;

function pullScripts(text) {
  var scripts = $("script", text).get();
  for (var i in scripts) {
    console.log(scripts[i].type);
    if(scripts[i].type === "text/x-pyropus-js") {
      $.getScript(scripts[i].getAttribute("href"));
    }
  }
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

  // rebind the new elements with this callback
  $("#content [data-remote]=true").bind("ajax:complete", retrievePage);
  $("#content [data-remote]=true").bind("ajax:before", ajaxLoading);

  $("#menubar [data-remote]=true").bind("ajax:complete", retrievePage);
  $("#menubar [data-remote]=true").bind("ajax:before", ajaxLoading);
  window.history.pushState(null, "Pyropus", sourceUrl);

  // this is the main hook for "Things"
  try {
    document.bootstrap();
  } catch (e) {}
}

function ajaxLoading(ev, e) {
  ajaxLoadingState = 1;

  $("#notice").hide();
  $("#alert").hide();

  $("#content").fadeOut(fadeTime, function() {
    ajaxLoadingState = 2;
  });
}

$(window).ready(function () {
//  $(".ajaxLink").click(ajaxNavigationLink);
  $("[data-remote]=true").bind("ajax:complete", retrievePage);
  $("[data-remote]=true").bind("ajax:before", ajaxLoading);
  pullScripts($(document).html());
});

})();

var Pyropus = (function () {
  var errorTimeout;

  function error (str) {
    clearTimeout(errorTimeout);
    $("#alert").html(str);
    $("#alert").fadeIn();
    $("#alert").click(function () {
      $(this).fadeOut();
    });
    errorTimeout = setTimeout(function () {
      $("#alert").fadeOut();
    }, 15000);
  }

  $(document).ajaxError(function (a,b,c) {
    error("An error has occured:</br><pre>" + b.status + ": " + b.statusText + "</pre>");
  });

  return {
    error: error
  };
})();
