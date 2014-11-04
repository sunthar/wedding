class User < ActiveRecord::Base

  def <=>(otherUser)
    u1_rsvp_yes = false
    u1_rsvp_no = false
    u1_rsvp_na = true
    u2_rsvp_yes = false
    u2_rsvp_no = false
    u2_rsvp_na = true
    ['rsvp_ceremony', 'rsvp_reception', 'rsvp_ca_reception'].each do |r|
      if self[r] && self[r] == 1
        u1_rsvp_yes = true
        u1_rsvp_na = false
      end
      if self[r] && self[r] == 0 && !u1_rsvp_yes
        u1_rsvp_no = true
        u1_rsvp_na = false
      end
      if otherUser[r] && otherUser[r] == 1
        u2_rsvp_yes = true
        u2_rsvp_na = false
      end
      if otherUser[r] && otherUser[r] == 0 && !u2_rsvp_yes
        u2_rsvp_no = true
        u2_rsvp_na = false
      end
    end
    if u1_rsvp_yes && u2_rsvp_yes
      self.last_name <=> otherUser.last_name
    elsif u1_rsvp_yes
      -1
    elsif u2_rsvp_yes
      1
    elsif u1_rsvp_no && u2_rsvp_no
      self.last_name <=> otherUser.last_name
    elsif u1_rsvp_no
      -1
    elsif u2_rsvp_no
      1
    else
      self.last_name <=> otherUser.last_name
    end
  end
end