class Board < ApplicationRecord
  include ConnectFour

  has_many :cells
  has_many :games

  validates_presence_of :width, :height

  def self.establish(w = 7, h = 6)
    b = find_available || create(width: w, height: h)
    b.create_cells if b.cells.blank?
    b
  end

  def self.play_in_console
    board = establish
    game = Game.establish(board)
    game.establish_players
    game.play
  end

  def self.find_available
    board = all.select { |b| unless b.any_active_game then b end }.first
    board.reset if board.present?
    board
  end

  def create_cells
    (0..self.width - 1).to_a.each do |x|
      (0..self.height - 1).to_a.each do |y|
        self.cells << Cell.create(x: x, y: y, value: "")
      end
    end
  end
end
