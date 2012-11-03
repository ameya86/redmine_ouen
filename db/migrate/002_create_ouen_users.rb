class CreateOuenUsers < ActiveRecord::Migration
  def change
    create_table :ouen_users do |t|
      t.integer :ouen_id
      t.integer :user_id 
      t.boolean :good
    end
    add_index :ouen_users, [:ouen_id, :user_id], :unique => true
  end
end
