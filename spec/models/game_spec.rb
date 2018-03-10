require 'rails_helper'

RSpec.describe Game, type: :model do
  let (:board) { Board.create(width: 7, height: 6) }
  let (:game1) { Game.create(board_id: board.id) }

  context "Validation" do
    it "is valid with valid attributes" do
      board = Board.create(width: 7, height: 6)
      game = Game.new(board_id: board.id)
      expect(game).to be_valid
    end
    it "is not valid without a board" do
      game = Game.new(board_id: nil)
      expect(game).to_not be_valid
    end
  end
  context "establish" do
    let (:game2) { Game.establish(board) }
    it "should create a new game using given board" do
      expect(game2.class).to eq Game
    end
    it "should have a human vs human kind" do
      expect(game2.kind).to eq ConnectFour::GAME_KINDS[:human_vs_human]
    end
    it "should have a new status" do
      expect(game2.status).to eq ConnectFour::STATUS[:new]
    end
  end
  context "reset" do
    it "should reset the board and set the status of the game to new" do
      game1.reset
      expect(board).to respond_to(:reset)
    end
  end
end
