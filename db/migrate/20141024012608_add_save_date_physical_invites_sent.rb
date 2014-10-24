class AddSaveDatePhysicalInvitesSent < ActiveRecord::Migration
  def change
    add_column :users, :save_date_sent, :integer
    add_column :users, :physical_invitation_sent, :integer
  end
end
