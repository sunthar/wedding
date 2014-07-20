class Admin::SplashController < AdminController

  def index
    @users = User.all
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
    int_fields = [12, 13, 15, 16, 17, 18, 19, 20, 21]
    headers = data.shift

    data.each do |row|
      u = User.find_by_full_name(row[2].to_s)
      if u.nil?
        u = User.create()
      end
      user_params = {}
      row.each_with_index do |val, idx|
        new_val = val.to_s
        new_val = val.to_i if int_fields.include?(idx)
        user_params[headers[idx]] = new_val unless val.blank?
      end
      user_params["other_people"] = user_params["other_people"].split(/\s*,\s*/) if user_params["other_people"]
      if u.access_code.blank?
        user_params["access_code"] = (0..5).map{ (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a )[rand(62)] }.join
      end
      u.update(user_params)
    end
    render :json => { :users => User.all } and return
  end

  def export
    fields = ["first_name", "last_name", "full_name", "salutation", "email", "access_code", "phone", "street_address", "city", "state", "zip", "other_people", "invited_to_ceremony", "invited_to_reception", "invited_by", "invitee_batch_a", "invitee_batch_b", "rsvp_ceremony", "rsvp_reception", "rsvp_sent", "reminder_sent", "wedding_info_sent", "table_number"]
    filename = "data-#{Time.now.strftime("%m-%d-%Y_%H-%M-%S")}"
    csv = fields.join(",") + "\n"
    id_to_other_names = {}
    User.all.each do |u|
      field_array = []
      fields.each{|f| field_array.push(u[f])}
      csv += (field_array.join(",") + "\n")
    end
    send_data(csv, :type => 'text/csv', :disposition => "attachment; filename=#{filename}")
  end

end