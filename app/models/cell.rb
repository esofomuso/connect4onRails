class Cell < ApplicationRecord
  belongs_to :board
  belongs_to :player, optional: true

  def by_cordinates(coords)
    Cell.where(x: coords[0], y: coords[1])
  end

  def set_value(value)
    update_attributes(value: value)
  end

  def coordinates
    [self.x, self.y]
  end
end
