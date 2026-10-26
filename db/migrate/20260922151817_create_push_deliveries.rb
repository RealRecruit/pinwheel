class CreatePushDeliveries < ActiveRecord::Migration[8.1]
  def change
    create_table :push_deliveries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
