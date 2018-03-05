class Board < ApplicationRecord
  has_many :cells
  has_many :games

  # coord [x,y] and each coordinate is added to the current one to find a win
  WINNING_RULES = {
    horizontal: [[0, 0], [1, 0], [2, 0], [3, 0]],
    vertical: [[0, 0], [0, 1], [0, 2], [0, 3]],
    up_diagonal: [[0, 0], [1, 1], [2, 2], [3, 3]],
    # down_diagonal: [[0, 0], [1, -1], [2, -2], [3, -3]],
    down_diagonal: [[0, 0], [-1, 1], [-2, 2], [-3, 3]],
  }

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

  # status 0 is newly established board and 1 is active game.
  def any_active_game
    self.games.where("status = 1").any?
  end

  # There are width number of columns
  def column(x)
    i = x - 1
    self.cells.where(x: i)
  end

  # There are height number of rows
  def row(y)
    i = y - 1
    self.cells.where(y: i)
  end

  # Clear all values
  def reset
    self.cells.update_all(value: "", player_id: nil)
  end

  # To use in the UI
  def grid
    rows = []
    (1..self.height).to_a.each do |h|
      rows << row(h)
    end
    rows.reverse
  end

  # To use in the console
  def console_grid
    rows = []
    (1..self.height).to_a.each do |h|
      rows << row(h).map { |cell| "[#{cell.value.empty? ? "_" : cell.value}]" }.join("")
    end
    rows
  end

  def draw_grid
    puts "*" * self.width * 3
    label = (1..self.width).map { |n| "(#{n})" }.join("")
    puts label
    puts console_grid.reverse.join("\n")
    puts "*" * self.width * 3
  end

  def add_to_col(col, value)
    if available_cells_by_col(col).size > 0
      next_available_cell(col).set_value(value)
    else
      false
    end
  end

  def game_over_message
    winner, coords = detect_win
    return "#{winner} won! Winning coordinates #{coords}" if winner
    return "The game ended in a tie" if tie?
    false
  end

  def tie?
    grid.flatten.map(&:value).none_empty?
  end

  def detect_win
    (1..self.height).to_a.each do |h|
      row(h).each do |cell|
        next if cell.value.blank?
        coords = cell.coordinates
        result = match_win_patterns(coords[0], coords[1])
        if result[0] != nil
          return result
        end
      end
    end
    return [nil, nil]
  end

  def match_win_patterns(x, y)
    WINNING_RULES.keys.each do |key|
      Rails.logger.debug "Testing for win in #{key} and pattern is #{WINNING_RULES[key]}"
      result = match_pattern(WINNING_RULES[key], x, y)
      return result if result[0].present?
    end
    return [nil, nil]
  end

  def match_pattern(pattern, x, y)
    coords = []
    player_colors = pattern.map do |coordinates|
      new_x = x + coordinates[0]
      new_y = y + coordinates[1]
      coords << [new_x, new_y]
      cell = cell_by_coords(new_x, new_y).first
      if cell.blank?
        nil
      else
        cell.value
      end
    end
    if player_colors.none_empty? && player_colors.all_same?
      [Player.find_by_color(player_colors.first).name, coords]
    else
      [nil, nil]
    end
  end

  private

  def create_cells
    (0..self.width - 1).to_a.each do |x|
      (0..self.height - 1).to_a.each do |y|
        self.cells << Cell.create(x: x, y: y, value: "")
      end
    end
  end

  def occupied_cells_by_col(col)
    column(col).where("value IS NOT ''")
  end

  def available_cells_by_col(col)
    column(col).where(value: '')
  end

  def next_available_cell(col)
    available_cells_by_col(col).first
  end

  def cell_by_coords(x, y)
    self.cells.by_cordinates([x, y])
  end
end
