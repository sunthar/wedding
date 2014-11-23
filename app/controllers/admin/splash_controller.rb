class Admin::SplashController < AdminController

  def index
    @users = User.all.sort
    @az_wedding = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @az_reception = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @ca_reception = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }

    #Bride counts
    @az_wedding_bride = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @az_reception_bride = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @ca_reception_bride = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    #Groom counts
    @az_wedding_groom = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @az_reception_groom = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @ca_reception_groom = {
      'yes' => 0,
      'no' => 0,
      'na' => 0
    }
    @users.each do |u|
      if u.invited_to_ceremony && u.invited_to_ceremony == 1
        if u.rsvp_ceremony == 1
          @az_wedding['yes'] += 1
        elsif u.rsvp_ceremony == 0
          @az_wedding['no'] += 1
        else
          @az_wedding['na'] += 1
        end
      end
      #Bride stuff
      if (u.invited_to_ceremony && u.invited_to_ceremony == 1) && (u.invited_by == "Preeth" || u.invited_by == "Rashmi" || u.invited_by == "preeth" || u.invited_by == "rashmi" )
        if u.rsvp_ceremony == 1
          @az_wedding_bride['yes'] += 1
        elsif u.rsvp_ceremony == 0
          @az_wedding_bride['no'] += 1
        else
          @az_wedding_bride['na'] += 1
        end
      end

      #Groom stuff
      if (u.invited_to_ceremony && u.invited_to_ceremony == 1) && (u.invited_by == "Sunthar" || u.invited_by == "Dhanya" || u.invited_by == "sunthar" || u.invited_by == "dhanya" )
        if u.rsvp_ceremony == 1
          @az_wedding_groom['yes'] += 1
        elsif u.rsvp_ceremony == 0
          @az_wedding_groom['no'] += 1
        else
          @az_wedding_groom['na'] += 1
        end
      end

      if u.invited_to_reception && u.invited_to_reception == 1
        if u.rsvp_reception == 1
          @az_reception['yes'] += 1
        elsif u.rsvp_reception == 0
          @az_reception['no'] += 1
        else
          @az_reception['na'] += 1
        end
      end
      #Bride stuff
      if (u.invited_to_reception && u.invited_to_reception == 1) && (u.invited_by == "Preeth" || u.invited_by == "Rashmi" || u.invited_by == "preeth" || u.invited_by == "rashmi" )
        if u.rsvp_reception == 1
          @az_reception_bride['yes'] += 1
        elsif u.rsvp_reception == 0
          @az_reception_bride['no'] += 1
        else
          @az_reception_bride['na'] += 1
        end
      end

      #Groom stuff
      if (u.invited_to_reception && u.invited_to_reception == 1) && (u.invited_by == "Sunthar" || u.invited_by == "Dhanya" || u.invited_by == "sunthar" || u.invited_by == "dhanya" )
        if u.rsvp_reception == 1
          @az_reception_groom['yes'] += 1
        elsif u.rsvp_reception == 0
          @az_reception_groom['no'] += 1
        else
          @az_reception_groom['na'] += 1
        end
      end


      if u.invited_to_ceremony && u.invited_to_ceremony == 1
        if u.rsvp_ca_reception == 1
          @ca_reception['yes'] += 1
        elsif u.rsvp_ca_reception == 0
          @ca_reception['no'] += 1
        else
          @ca_reception['na'] += 1
        end
      end

      #Bride stuff
      if (u.invited_to_ceremony && u.invited_to_ceremony == 1) && (u.invited_by == "Preeth" || u.invited_by == "Rashmi" || u.invited_by == "preeth" || u.invited_by == "rashmi"  )
        if u.rsvp_ca_reception == 1
          @ca_reception_bride['yes'] += 1
        elsif u.rsvp_ca_reception == 0
          @ca_reception_bride['no'] += 1
        else
          @ca_reception_bride['na'] += 1
        end
      end

      #Groom stuff
      if (u.invited_to_ceremony && u.invited_to_ceremony == 1) && (u.invited_by == "Sunthar" || u.invited_by == "Dhanya" || u.invited_by == "sunthar" || u.invited_by == "dhanya" )
        if u.rsvp_ca_reception == 1
          @ca_reception_groom['yes'] += 1
        elsif u.rsvp_ca_reception == 0
          @ca_reception_groom['no'] += 1
        else
          @ca_reception_groom['na'] += 1
        end
      end
    end
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
    int_fields = [12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26]
    headers = data.shift

    data.each do |row|
      u = User.find_by_full_name(row[2].to_s)
      if u.nil?
        u = User.create()
      end
      user_params = {}
      row.each_with_index do |val, idx|
        new_val = val.to_s
        new_val = val.to_i if new_val && int_fields.include?(idx)
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
    fields = ["first_name", "last_name", "full_name", "salutation", "email", "access_code", "phone", "street_address", "city", "state", "zip", "other_people", "invited_to_ceremony", "invited_to_reception", "invited_to_ca_reception", "invited_by", "invitee_batch_a", "invitee_batch_b", "rsvp_ceremony", "rsvp_reception", "rsvp_ca_reception", "rsvp_sent", "reminder_sent", "wedding_info_sent", "table_number", "save_date_sent", "physical_invitation_sent"]
    filename = "data-#{Time.now.strftime("%m-%d-%Y_%H-%M-%S")}"
    csv = fields.join(",") + "\n"
    id_to_other_names = {}
    User.all.each do |u|
      field_array = []
      fields.each do |f|
        f == "other_people" ? field_array.push("\"#{u[f].join(", ")}\"") : field_array.push("\"#{u[f]}\"")
      end
      csv += (field_array.join(",") + "\n")
    end
    send_data(csv, :type => 'text/csv', :disposition => "attachment; filename=#{filename}")
  end

end