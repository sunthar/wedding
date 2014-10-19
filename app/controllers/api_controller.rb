class ApiController < ApplicationController

  def check_rsvp_credentials
    begin
      email = params[:email]
      passcode = params[:passcode]
      u = User.where(:email => email.downcase.strip).first
      raise "User not found with email" if u.nil?
      raise "Incorrect passcode" unless passcode == u.access_code
      invites = []
      invites.push("ceremony") if u.invited_to_ceremony == 1
      invites.push("reception") if u.invited_to_reception == 1
      invites.push("careception") if u.invited_to_ca_reception == 1
      people = [u]
      u.other_people.each do |full_name|
        other_u = User.where(:full_name => full_name).first
        people.push(other_u) unless other_u.nil?
      end
      @result = {
        :name => u.first_name,
        :people => people,
        :invites => invites,
        :user_id => u.id
      }
    rescue Exception => e
      @error = e.message
    end

    respond_to do |format|
      format.json {
        render json: {
          "result" => @result,
          "error" => @error
        },
        status: :ok
      }
    end
  end

  def rsvp
    begin
      info = params[:params]
      uid = info['rsvp_user_id']
      u = User.find(uid)
      u.update({
        :street_address => info['address'],
        :city => info['city'],
        :state => info['state'],
        :zip => info['zip'],
        :phone => info['cell'],
        :note => info['note']
      })
      info['rsvps'].each do |idx, rsvp_info|
        next if rsvp_info['invites'].to_s == 'no'
        answer = 0
        answer = 1 if rsvp_info['answer'].to_s == 'yes'
        field = 'rsvp_' + rsvp_info['invites'].to_s
        field = 'rsvp_ca_reception' if field == 'rsvp_careception'
        User.find(rsvp_info['uid'].to_i).update(:"#{field}" => answer)
      end
      @result = "OK"
    rescue Exception => e
      @error = e.message
    end

    respond_to do |format|
      format.json {
        render json: {
          "result" => @result,
          "error" => @error
        },
        status: :ok
      }
    end
  end

end
