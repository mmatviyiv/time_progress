class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :team
      t.string :name
      t.string :slack_id, null: false
      t.string :access_token, null: false
      t.boolean :revoked, default: false

      t.timestamps
    end

    add_index :users, [:team_id, :slack_id], unique: true, where: 'NOT revoked'
  end
end
