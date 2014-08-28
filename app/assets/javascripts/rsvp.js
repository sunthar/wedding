$(document).ready(function() {
  $("#review_rsvp_options").click(function() {
    var email = $("#rsvp_email").val();
    var passcode = $("#rsvp_passcode").val();
    if (!email || !passcode) {
      alert("Fill out the forms man!");
      return false;
    }
    PS.call("check_rsvp_credentials", {email: email, passcode: passcode}, function(data) {
      console.log(data);
      $("#rsvp_hi").html("Hi " + data.name + "!");
      var checkboxHTML = "";
      for (var i = 0; i < data.invites.length; i++) {
        for (var j = 0; j < data.people.length; j++) {
          var name = data.people[j].first_name + " is also coming";
          if (data.people[j].id == data.user_id)
            name = "I am coming";
          var event = "Wedding Ceremony";
          if (data.invites[i] == "reception")
            event = "Wedding Reception";
          if (data.invites[i] == "ca_reception")
            event = "California Wedding Reception";
          checkboxHTML += '<div class="checkbox"><label><input type="checkbox"> ' + name + ' for the <strong>' + event + '</strong></label></div>';
        }
      }
      $("#rsvp_checkboxes").html(checkboxHTML);
      $("#rsvp_first").hide();
      $("#rsvp_second").show();
    }, function(err) {
      $("#rsvp_invalid").show();
    });
    return false;
  });
  $("#rsvp_submit").click(function() {
    var address = $("#rsvp_note").val();
    var city = $("#rsvp_city").val();
    var state = $("#rsvp_state").val();
    var zip = $("#rsvp_zip").val();
    var cell = $("#rsvp_cell").val();
    var note = $("#rsvp_note").val();

    $("#rsvp_second").hide();
    $("#rsvp_third").show();
    return false;
  });
});