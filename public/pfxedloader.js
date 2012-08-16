Pyropus.startup(function () {
  var drawMirror
    , initMirror
    , updateMirror
    , i
    ;

  textAreas = $('#function-texts textarea').get(); 

  function listSamples () {
    $.ajax({
      url: "/pfxed/list",
      dataType: "json",
      success: function (data) {
        $("#sample-select").html("");
        for (var i in data) {
          $("#sample-select").append(
            $("<option value='" + data[i].id + "'>" + data[i].name + "</option>")
          );
        }
        $("#sample-select").val($("#sample-id").val());
        loadSample();
      }
    });
  }

  function newSample () {
    $.ajax({
      url: "/pfxed",
      type: "POST",
      dataType: "json",
      success: function (d) {
        console.log(d);
        listSamples();
        Pyropus.notice("Created successfully");
      }
    });
  }

  function loadSample () {
    var id = $("#sample-select").val() || $("#sample-id").val();
    $.ajax({
      url: "/pfxed/" + id,
      dataType: "json",
      success: function (data) {

        drawMirror.setValue(data.draw_function || "");
        initMirror.setValue(data.init_function || "");
        updateMirror.setValue(data.update_function || "");

        $("#sample-id").val(data.id);
        $("#sample-name").val(data.name);

        $("#maxParticles").val(data.max_particles);
        $("#emitFrequency").val(data.emit_frequency);
        $("input[name=boundaryAction][type=" + data.boundary_action + "]").checked = true;

        PfxEd.stop();
        PfxEd.start();
        PfxEd.run();

      }
    });
  }

  function loadRandomSample () {
    $.ajax({
      url: "/pfxed/random",
      dataType: "json",
      success: function (data) {
        $("#init-function").val(data.init_function);
        $("#draw-function").val(data.draw_function);
        $("#update-function").val(data.update_function);
        $("#sample-id").val(data.id);
        $("#sample-name").val(data.name);
        $("#sample-select").val($("#sample-id").val());

        PfxEd.stop();
        PfxEd.start();
        PfxEd.run();
      }
    });
  }

  function deleteSample () {
    $.ajax({
      url: "/pfxed/" + $("#sample-id").val(),
      type: "DELETE",
      dataType: "json",
      success: function (d) {
        listSamples();
        Pyropus.notice("Deleted successfully");
      }
    });
  }

  function saveSample () {
    var data = {
      id: $("#sample-id").val(),
      sample: {
        init_function: $("#init-function").val(),
        draw_function: $("#draw-function").val(),
        update_function: $("#update-function").val(),
        max_particles: $("#maxParticles").val(),
        emit_frequency: $("#emitFrequency").val(),
        boundary_action: $("input[name=boundaryAction]:checked").val(),
        name: $("#sample-name").val()
      }
    };

    $.ajax({
      url: "/pfxed/" + data.id,
      type: "PUT",
      dataType: "json",
      data: data,
      success: function (d) {
        listSamples();
        Pyropus.notice("Saved successfully");
      }
    });

    return false;
  }

  $("#content")
    .append($('<input type="hidden" id="sample-id" name="id" value="<%= if (@sample) then @sample.id end %>">'))
    .append($('<select id="sample-select"></select>'))
    .append($('<input type="text" id="sample-name">'))
    .append($('<button id="new-sample">New</button>'))
    .append($('<button id="save-sample">Save</button>'))
    .append($('<button id="delete-sample">Delete</button>'))
    .append($('<button id="random-sample">Random</button>'));

  PfxEd.init($("#content"));

  $("#save-sample").click(saveSample);
  $("#new-sample").click(newSample);
  $("#delete-sample").click(deleteSample);
  $("#random-sample").click(loadRandomSample);
  $("#sample-select").change(loadSample);

  var options = {
    lineNumbers: true,
    mode: 'text/javascript'
  };

  drawMirror = CodeMirror.fromTextArea($('#draw-function').get()[0], {
    lineNumbers: true,
    mode: 'text/javascript',
    onChange: function () {
      $("#draw-function").val(drawMirror.getValue());
    }
  });

  initMirror = CodeMirror.fromTextArea($('#init-function').get()[0], {
    lineNumbers: true,
    mode: 'text/javascript',
    onChange: function () {
      $("#init-function").val(initMirror.getValue());
    }
  });

  updateMirror = CodeMirror.fromTextArea($('#update-function').get()[0], {
    lineNumbers: true,
    mode: 'text/javascript',
    onChange: function () {
      $("#update-function").val(updateMirror.getValue());
    }
  });

  listSamples();

});

Pyropus.teardown(function () {
  PfxEd.destroy();
});
