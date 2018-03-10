class Cell < ApplicationRecord
  belongs_to :board
  belongs_to :player, optional: true

  validates_presence_of :x, :y

  def self.by_coordinates(coords)
    Cell.where(x: coords[0], y: coords[1])
  end

  def set_value(value)
    update_attributes(value: value)
  end

  def coordinates
    [self.x, self.y]
  end
end
