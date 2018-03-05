class Player < ApplicationRecord
  belongs_to :game, optional: true
end
