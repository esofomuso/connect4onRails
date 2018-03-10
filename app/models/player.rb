class Player < ApplicationRecord
  belongs_to :game, optional: true
  has_one :current_game, class_name: "Game", foreign_key: :current_player_id

  validates_presence_of :color, :name
end
