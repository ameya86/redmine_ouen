class CreateOuens < ActiveRecord::Migration
  def change
    create_table :ouens do |t|
      t.integer :content_id,   :default => '0', :null => false
      t.string  :content_type,                  :null => false
      t.integer :good_count,   :default => '0'
      t.integer :more_count,   :default => '0'
    end
  end
end
