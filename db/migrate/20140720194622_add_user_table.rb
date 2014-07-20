class AddUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :salutation
      t.string :email
      t.string :access_code
      t.string :phone
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :other_people, array: true, default: '{}'
      t.integer :invited_to_ceremony
      t.integer :invited_to_reception
      t.string :invited_by
      t.integer :invitee_batch_a
      t.integer :invitee_batch_b
      t.integer :rsvp_ceremony
      t.integer :rsvp_reception
      t.integer :rsvp_sent
      t.integer :reminder_sent
      t.integer :wedding_info_sent
      t.string :table_number
      t.integer :permission
      t.string :pass_md5

      t.timestamps
    end
  end
end
