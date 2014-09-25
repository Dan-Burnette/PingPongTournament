class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.belongs_to :tournament
      #t.belongs_to :player
      t.integer :player1
      t.integer :player2
      t.integer :winner
    end
  end
end
