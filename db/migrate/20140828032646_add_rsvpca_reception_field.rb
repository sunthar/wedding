class AddRsvpcaReceptionField < ActiveRecord::Migration
  def change
    add_column :users, :rsvp_ca_reception, :integer
  end
end
