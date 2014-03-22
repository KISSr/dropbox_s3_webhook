class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :dropbox_user_id
      t.string :cursor
      t.string :token

      t.timestamps
    end
  end
end
