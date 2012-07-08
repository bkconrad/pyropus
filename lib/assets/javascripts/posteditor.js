var MDEditor;
Pyropus.queue(function () {
  if (document.getElementById("wmd-input") && !MDEditor) {
    MDEditor = new Markdown.Editor(new Markdown.Converter);
    MDEditor.run();
  }
});
console.log("running");
