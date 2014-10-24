$(document).ready(function() {
  var rsvp_user_id;
  var setupRSVPInfo = function(data) {
    $("#rsvp_hi").html("Hi " + data.name + "!");
    var checkboxHTML = "";
    rsvp_user_id = data.user_id;
    for (var j = 0; j < data.people.length; j++) {
      var name = data.people[j].first_name;
      if (data.people[j].id == data.user_id)
        name = "I";
        for (var i = 0; i < data.invites.length; i++) {
        var event = "Wedding Ceremony";
        if (data.invites[i] == "reception")
          event = "Wedding Reception";
        if (data.invites[i] == "careception")
          event = "California Wedding Reception";
        checkboxHTML += '<div class="checkbox"><label><input type="checkbox" class="rsvp_checkbox" id="' + data.invites[i] + '_' + data.people[j].id + '"> ' + name + (name == "I" ? " am" : " is") + ' coming for the <strong>' + event + '</strong></label></div>';
      }
      checkboxHTML += '<div class="checkbox"><label><input type="checkbox" class="rsvp_checkbox" id="no_' + data.people[j].id + '"> ' + name + ' can\'t make it</label></div>';
    }
    $("#rsvp_checkboxes").html(checkboxHTML);
    $("#rsvp_first").hide();
    $("#rsvp_second").show();
  };
  $("#review_rsvp_options").click(function() {
    var email = $("#rsvp_email").val();
    var passcode = $("#rsvp_passcode").val();
    if (!email || !passcode) {
      alert("Please fill out your email and passcode!");
      return false;
    }
    PS.call("check_rsvp_credentials", {email: email, passcode: passcode}, function(data) {
      setupRSVPInfo(data);
    }, function(err) {
      $("#rsvp_invalid").show();
      $('html, body').animate({
        scrollTop: ($('#rsvp_invalid').first().offset().top-100)
      },500);
    });
    return false;
  });
  $("#rsvp_submit").click(function() {
    $("#rsvp_no_rsvp").hide();
    $("#rsvp_all_fields").hide();
    var address = $("#rsvp_address").val();
    var city = $("#rsvp_city").val();
    var state = $("#rsvp_state").val();
    var zip = $("#rsvp_zip").val();
    var cell = $("#rsvp_cell").val();
    var note = $("#rsvp_note").val();
    var uidDidRSVP = {};
    var rsvps = [];
    $(".rsvp_checkbox").each(function() {
      var cid = $(this).attr("id");
      var invites = cid.split("_")[0];
      var uid = cid.split("_")[1];
      var rsvp = {
        uid: uid,
        invites: invites
      }
      if (!uidDidRSVP[uid])
        uidDidRSVP[uid] = "no";
      if ($(this).is(":checked")) {
        uidDidRSVP[uid] = "yes";
        rsvp.answer = "yes";
      } else {
        rsvp.answer = "no";
      }
      rsvps.push(rsvp);
    });
    for (var uid in uidDidRSVP) {
      if (uidDidRSVP[uid] == "no") {
        $("#rsvp_no_rsvp").show();
        $('html, body').animate({
          scrollTop: ($('#rsvp_no_rsvp').first().offset().top-100)
        },500);
        return false;
      }
    }
    if (!address || !city || !state || !zip || !cell) {
      $("#rsvp_all_fields").show();
      $('html, body').animate({
        scrollTop: ($('#rsvp_all_fields').first().offset().top-100)
      },500);
      return false;
    }
    var params = {
      address: address, city: city, state: state, zip: zip,
      cell: cell, note: note,
      rsvp_user_id: rsvp_user_id,
      rsvps: rsvps
    }
    PS.call("rsvp", {params:params}, function(data) {
      $("#rsvp_second").hide();
      $("#rsvp_third").show();
    }, function(err) {
      alert("Error: " + err);
    });
    return false;
  });
  if (typeof (ACCESS_DATA) != "undefined" && ACCESS_DATA) {
    setupRSVPInfo(ACCESS_DATA);
    ACCESS_DATA = false;
  }
});