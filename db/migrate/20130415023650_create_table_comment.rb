class CreateTableComment < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
  		t.integer :pin_id
  		t.integer :user_id		
      t.text :content


      t.timestamps
    end
  end
end

