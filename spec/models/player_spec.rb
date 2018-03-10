require 'rails_helper'

RSpec.describe Player, type: :model do
  it "is valid with valid attributes" do
    player = Player.new(color: 'X', name: 'Doe')
    expect(player).to be_valid
  end
  it "is not valid without a color" do
    player = Player.new(color: nil)
    expect(player).to_not be_valid
  end
  it "is not valid without a name" do
    player = Player.new(name: nil)
    expect(player).to_not be_valid
  end
end
