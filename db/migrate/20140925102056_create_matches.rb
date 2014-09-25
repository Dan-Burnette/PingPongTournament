class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.belongs_to :tournament
      t.belongs_to :player
      t.integer :winner
    end
  end
end
