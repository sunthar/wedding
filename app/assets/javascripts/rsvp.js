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
        var isChecked = false;
        if (data.invites[i] == "reception")
          event = "Wedding Reception";
        if (data.invites[i] == "careception")
          event = "California Wedding Reception";
        if (event == "Wedding Ceremony" && data.people[j].rsvp_ceremony && data.people[j].rsvp_ceremony == 1)
          isChecked = true;
        if (event == "Wedding Reception" && data.people[j].rsvp_reception && data.people[j].rsvp_reception == 1)
          isChecked = true;
        if (event == "California Wedding Reception" && data.people[j].rsvp_ca_reception && data.people[j].rsvp_ca_reception == 1)
          isChecked = true;

        checkboxHTML += '<div class="checkbox"><label><input type="checkbox" class="rsvp_checkbox" id="' + data.invites[i] + '_' + data.people[j].id + '"' + (isChecked ? ' checked' : '') + '> ' + name + (name == "I" ? " am" : " is") + ' coming for the <strong>' + event + '</strong></label></div>';
      }
      var anyRSVP = false;
      var anyOne = false;
      if (data.people[j].rsvp_ceremony != null || data.people[j].rsvp_reception != null || data.people[j].rsvp_ca_reception != null) {
        anyRSVP = true;
        if (data.people[j].rsvp_ceremony && data.people[j].rsvp_ceremony == 1 || data.people[j].rsvp_reception && data.people[j].rsvp_reception == 1 || data.people[j].rsvp_ca_reception && data.people[j].rsvp_ca_reception == 1)
          anyOne = true;
      }
      checkboxHTML += '<div class="checkbox"><label><input type="checkbox" class="rsvp_checkbox" id="no_' + data.people[j].id + '"' + (anyRSVP && !anyOne ? ' checked' : '') + '> ' + name + ' can\'t make it</label></div>';
    }
    $("#rsvp_checkboxes").html(checkboxHTML);
    $(".rsvp_checkbox").change(function() {
      if ($(this).attr("id").indexOf("no_") > -1) {
        if ($(this).is(":checked")) {
          var uid = $(this).attr("id").split("_")[1];
          $("#ceremony_" + uid).attr('checked', false);
          $("#reception_" + uid).attr('checked', false);
          $("#careception_" + uid).attr('checked', false);
        }
      } else {
        if ($(this).is(":checked")) {
          var uid = $(this).attr("id").split("_")[1];
          $("#no_" + uid).attr('checked', false);
        }
      }
    });
    if (data.user.street_address)
      $("#rsvp_address").val(data.user.street_address);
    if (data.user.city)
      $("#rsvp_city").val(data.user.city);
    if (data.user.state)
      $("#rsvp_state").val(data.user.state);
    if (data.user.zip)
      $("#rsvp_zip").val(data.user.zip);
    if (data.user.phone)
      $("#rsvp_cell").val(data.user.phone);
    if (data.user.note)
      $("#rsvp_note").val(data.user.note);


    $("#rsvp_first").hide();
    $("#rsvp_second").show();
    $('html, body').animate({
      scrollTop: ($('#rsvp_head').first().offset().top+20)
    },500);
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
    var someoneCanGo = false;
    for (var i = 0; i < rsvps.length; i++) {
      if (rsvps[i].answer == "yes" && rsvps[i].invites != "no")
        someoneCanGo = true;
    }
    for (var uid in uidDidRSVP) {
      if (uidDidRSVP[uid] == "no") {
        $("#rsvp_no_rsvp").show();
        $('html, body').animate({
          scrollTop: ($('#rsvp_no_rsvp').first().offset().top-100)
        },500);
        return false;
      }
    }
    if (someoneCanGo && (!address || !city || !state || !zip || !cell)) {
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