document.bootstrap = function () {
  if (document.getElementById("wmd-input")) {
    console.log("Firing");
    (new Markdown.Editor(new Markdown.Converter)).run();
  }
};
$(document).ready(document.bootstrap);
