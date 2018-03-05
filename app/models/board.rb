class Board < ApplicationRecord
  has_many :cells
  has_many :games
end
