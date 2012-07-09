var MDEditor;
Pyropus.startup(function () {
  if (document.getElementById("wmd-input") && !MDEditor) {
    MDEditor = new Markdown.Editor(new Markdown.Converter);
    MDEditor.run();
  }
});

Pyropus.teardown(function () {
  MDEditor = undefined;
});
