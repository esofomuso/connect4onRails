class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :current_player_id
      t.integer :status
      t.integer :board_id
      t.timestamps
    end
  end
end
