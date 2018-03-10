require 'rails_helper'

RSpec.describe Board, type: :model do
  let (:board) { Board.create(width: 7, height: 6) }

  context "Validation" do
    it "is valid with valid attributes" do
      board = Board.new(width: 7, height: 6)
      expect(board).to be_valid
    end
    it "is not valid without a width" do
      board = Board.new(width: nil, height: 6)
      expect(board).to_not be_valid
    end
    it "is not valid without a height" do
      board = Board.new(width: 7, height: nil)
      expect(board).to_not be_valid
    end
  end
  context "establish" do
    let(:board2) { Board.establish(7, 6) }
    it "should check if board is available" do
      expect(Board).to respond_to(:find_available)
    end
    it "should create a new board if none is available" do
      expect(board2.class).to eq Board
    end
    it "should create cells for the board" do
      expect(board2).to respond_to(:create_cells)
    end
  end
  context "play_in_console" do
    it "should check if board is available" do
      board
      allow(Board).to receive(:play_in_console)
      expect(Board).to respond_to(:establish) { board }
    end
  end
end
