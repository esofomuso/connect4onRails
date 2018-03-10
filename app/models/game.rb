class Game < ApplicationRecord
  include ConnectFour

  has_many :players, class_name: "Player"
  belongs_to :current_player, class_name: "Player", optional: true
  belongs_to :board

  attr_accessor :kind

  def self.establish(board, kind = GAME_KINDS[:human_vs_human])
    g = create(board_id: board.id, status: STATUS[:new])
    g.kind = kind
    g
  end

  def reset
    board.reset
    self.update_attribute(:status, STATUS[:new])
  end
end
