require 'rails_helper'

RSpec.describe Cell, type: :model do
  let (:board) { Board.create(width: 7, height: 6) }
  let (:cell1) { Cell.create(board_id: board.id, x: 1, y: 1) }

  context "Validation" do
    it "is valid with valid attributes" do
      cell = Cell.new(board_id: board.id, x: 0, y: 0)
      expect(cell).to be_valid
    end
    it "is not valid without a board" do
      cell = Cell.new(board_id: nil)
      expect(cell).to_not be_valid
    end
    it "is not valid without an x" do
      cell = Cell.new(x: nil)
      expect(cell).to_not be_valid
    end
    it "is not valid without a y" do
      cell = Cell.new(y: nil)
      expect(cell).to_not be_valid
    end
  end
  context "coordinates" do
    it "returns x and y values" do
      expect(cell1.coordinates).to eq [1, 1]
    end
    it "finds the cells with the given coordinates" do
      cell1
      expect(Cell.by_coordinates([1, 1]).first).to eq cell1
    end
  end
  context "set_value" do
    it "sets the value to the given argument" do
      cell1.set_value('X')
      expect(cell1.value).to eq 'X'
    end
  end
end
