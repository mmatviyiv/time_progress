class CreateNotifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :notifiers do |t|
      t.belongs_to :user
      t.belongs_to :team
      t.string :progress_type, null: false
      t.string :channel_id, null: false
      t.string :cron, null: false
      t.boolean :inactive, default: false

      t.timestamps
    end

    add_index :notifiers, [:team_id, :channel_id, :progress_type], unique: true, where: 'NOT inactive'
  end
end
