class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :slack_id, null: false
      t.boolean :uninstalled, default: false

      t.timestamps
    end

    add_index :teams, :slack_id, unique: true
  end
end
