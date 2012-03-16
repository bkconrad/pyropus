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
function retrievePage(ev, e) {

  $("#notice").hide();

  // get the url from the link or form
  var sourceUrl = $(this).context.href;
  if (sourceUrl == undefined) {
    sourceUrl = $(this).context.action;
  }
  var dom = $(e.responseText);

  // replace the content and header
  $("#content").fadeOut(100, function () {
    $("#content").html($("#content", dom).html());
    $("#content").fadeIn(100);

    // rebind the new elements with this callback
    $("[data-remote]=true").bind("ajax:complete", retrievePage);
  });
  $("#header").html($("#header", dom).html());
}
$(window).ready(function () {
//  $(".ajaxLink").click(ajaxNavigationLink);
  $("[data-remote]=true").bind("ajax:complete", retrievePage);
});
