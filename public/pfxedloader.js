$(document).ready(function () {
  function listSamples () {
    $.ajax({
      url: "/pfxed/list",
      dataType: "json",
      success: function (data) {
        console.log(data);
        $("#sample-select").html("");
        for (var i in data) {
          $("#sample-select").append(
            $("<option value='" + data[i].id + "'>" + data[i].name + "</option>")
          );
        }
        $("#sample-select").val($("#sample-id").val());
      }
    });
  }

  function newSample () {
    $.ajax({
      url: "/pfxed",
      type: "POST",
      dataType: "json",
      success: function (d) {
        listSamples();
      }
    });
  }

  function loadSample () {
    var id = $("#sample-select").val() || $("#sample-id").val();
    $.ajax({
      url: "/pfxed/" + id,
      dataType: "json",
      success: function (data) {
        $("#init-function").val(data.init_function);
        $("#draw-function").val(data.draw_function);
        $("#update-function").val(data.update_function);
        $("#sample-id").val(data.id);
        $("#sample-name").val(data.name);
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
      }
    });

    return false;
  }

  init($("#content"));

  listSamples();
  loadSample();

  $("#save-sample").click(saveSample);
  $("#new-sample").click(newSample);
  $("#delete-sample").click(deleteSample);
  $("#random-sample").click(loadRandomSample);
  $("#sample-select").change(loadSample);

});
