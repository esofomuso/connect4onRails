class Game < ApplicationRecord
  STATUS = {new: 0, started: 1, ended: 2}
  has_many :players, class_name: "Player"
  belongs_to :current_player, class_name: "Player", optional: true
  belongs_to :board
end
