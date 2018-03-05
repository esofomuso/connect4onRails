class CreateCells < ActiveRecord::Migration[5.1]
  def change
    create_table :cells do |t|
      t.string :value # Still to decide if this will be used, or simply rely on player.color
      t.integer :x
      t.integer :y
      t.integer :board_id
      t.integer :player_id
      t.timestamps
    end
  end
end
