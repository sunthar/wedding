class AddCaReceptionField < ActiveRecord::Migration
  def change
    add_column :users, :invited_to_ca_reception, :integer
  end
end
