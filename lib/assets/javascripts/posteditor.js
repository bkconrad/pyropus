var MDEditor;
Pyropus.startup(function () {
  if (document.getElementById("wmd-input") && !MDEditor) {
    MDEditor = new Markdown.Editor(new Markdown.Converter);
    MDEditor.run();
  }
  console.log('startup');
});

Pyropus.teardown(function () {
  MDEditor = undefined;
});
