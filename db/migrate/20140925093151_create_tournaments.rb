class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :num_players
      t.belongs_to :player
    end
  end
end
