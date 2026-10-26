class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :platform, null: false
      t.string :token, null: false
      t.string :name
      t.datetime :last_seen_at

      t.timestamps
    end
    add_index :devices, :token, unique: true
  end
end
