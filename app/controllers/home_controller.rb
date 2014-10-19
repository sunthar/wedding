class HomeController < ApplicationController
  def index

  end

  def rsvp
    @rsvp = true
    if params[:access_code]
      u = User.where(:access_code => params[:access_code]).first
      if u
        invites = []
        invites.push("ceremony") if u.invited_to_ceremony == 1
        invites.push("reception") if u.invited_to_reception == 1
        invites.push("careception") if u.invited_to_ca_reception == 1
        people = [u]
        u.other_people.each do |full_name|
          other_u = User.where(:full_name => full_name).first
          people.push(other_u) unless other_u.nil?
        end
        @access_data = {
          :name => u.first_name,
          :people => people,
          :invites => invites,
          :user_id => u.id
        }
      end
    end
    return render 'index'
  end
end