class Admin::SplashController < AdminController

  def index

  end

  def import
    require 'csv'
    client = GData::Client::Spreadsheets.new
    response = client.get("https://docs.google.com/spreadsheets/d/1HVdJa2PpYX4__zX_Xu8DQYmgL0w1yosHN0KEKOKAyzs/export?format=csv")
    now = Time.now.to_i
    file = File.new("import_#{now}.csv", "wb")
    file.write response.body
    file.close
    data = CSV.open(file, 'r')
    headers = data.shift

    data.each do |row|

    end
    render :json => { :users => User.all }
  end

  def export
    filename = "data-#{Time.now.strftime("%m-%d-%Y_%H-%M-%S")}"
    csv = ["first_name", "last_name", "full_name", "salutation", "email", "access_code", "phone", "street_address", "city", "state", "zip", "other_people", "invited_to_ceremony", "invited_to_reception", "invited_by", "invitee_batch_a", "invitee_batch_b", "rsvp_ceremony", "rsvp_reception", "rsvp_sent", "reminder_sent", "wedding_info_sent", "table_number"].join(",") + "\n"
    id_to_other_names = {}
    User.all.each do |u|
      csv += ([u.first_name, u.last_name, u.full_name, u.salutation, u.email, u.access_code, u.phone, u.street_address, u.city, u.stat, u.zip, u.other_people.join(", "), u.invited_to_ceremony, u.invited_to_reception, u.invited_by, u.invitee_batch_a, u.invitee_batch_b, u.rsvp_ceremony, u.rsvp_reception, u.rsvp_sent, r.reminder_sent, u.wedding_info_sent, u.table_number].join(",") + "\n")
    end
    send_data(csv, :type => 'text/csv', :disposition => "attachment; filename=#{filename}")
  end

end