var $displayDiv;

function clearDisplay () {
  $displayDiv.html("");
}

/* converts a bill.number to a bill-id used in API calls */
function formalizeBillId (str) {
  return str.replace(/[ .]+/g, "").toLowerCase();
}

function billDetails (billId) {
  billId = formalizeBillId(billId);
  $.ajax("/congress/query/bill-details/" + billId,
      { "success" : showBillDetails,
        "error" : showError });
}

function showBillDetails (details) {
  console.log(details);

  // TODO: sometimes the details come as a string?
  if (typeof(details) == "string")
    details = jQuery.parseJSON(details);

  var template = Handlebars.compile($("#bill-details-template").html());
  var html = template(details);
  if (details.bill)
    $("#current-bill").html("- " + details.bill);
  $("#bill-details").html(html);
}

function showBills (data, chamber) {
  console.log (data);
  if (typeof(data) === "string")
    data = $.parseJSON(data);
  var $element = $("#" + chamber + "-bills");
  $element.html("&nbsp;");
  var bill;
  var template = Handlebars.compile($("#bills-template").html());
  var html;
  for (var i = 0; i < data.length; i++) {
    bill = data[i];
    bill.id = formalizeBillId(bill.number);
   html = template(
                    {parity: ["even","odd"][i%2],
                     bill_id: bill.id,
                     bill_number: bill.number,
                     bill_title: bill.title,
                     bill_date: bill.introduced_date});
    $(html).appendTo($element);
  }
}

/* gets recent bills for both chambers of the selected type */
function getBills () {
  var type = $("#bill-types :checked").attr("id");

  // capitalize type for use in the title
  var titleType = type[0].toUpperCase() + type.slice(1);

  // build accordion section title, special logic for type 'major'
  var headerTitle = type == "major" ?
                    "Recent Major Bills" :
                    "Recently " + titleType + " Bills";
  $("#bill-list-current-type").html("- " + headerTitle);

  $.ajax("/congress/query/recent-bills/house/" + type,
      { "success" :
        function (data) {
          showBills (data, "house");
        }
      }
  );
  $.ajax("/congress/query/recent-bills/senate/" + type,
      { "success" :
        function (data) {
          showBills (data, "senate");
        }
      }
  );
}

function showError (request, state, error) {
  console.log(error);
}

Pyropus.startup(function () {
  console.log('startup');

  // Handlebars setup
  Handlebars.registerHelper("trim_date", function () {
    return this.datetime.split(" ")[0];
  });

  // UI prep
  $displayDiv = $("#congress-display");

  $("#congress-accordion").accordion({
    active: 2,
    animated: false,
    autoHeight: false,
    icons: false,
    collapsible: true
  });

  $("#bill-search").submit(function () {
    billDetails($("#bill-search-text").val());
  });

  $displayDiv.tabs();

  $("#bill-types").buttonset();
  $("#bill-types :radio").change(getBills);

  // TODO: move busy indicator code to global js
  $.ajaxSetup({ error: showError });
  $("#busy").ajaxStart (function () {
    $(this).show();
  });
  $("#busy").ajaxStop (function () {
    $(this).hide();
  });
  getBills();
  billDetails("s365");
});
