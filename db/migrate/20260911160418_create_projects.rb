class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :account, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.text :description
      t.datetime :archived_at

      t.timestamps
    end
    add_index :projects, %i[ account_id archived_at ]
  end
end
