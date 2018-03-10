module ConnectFour

  # coord [x,y] and each coordinate is added to the current one to find a win
  WINNING_RULES = {
    horizontal: [[0, 0], [1, 0], [2, 0], [3, 0]],
    vertical: [[0, 0], [0, 1], [0, 2], [0, 3]],
    up_diagonal: [[0, 0], [1, 1], [2, 2], [3, 3]],
    down_diagonal: [[0, 0], [-1, 1], [-2, 2], [-3, 3]],
  }
  STATUS = {new: 0, started: 1, ended: 2}
  GAME_KINDS = {human_vs_human: 0, human_vs_computer: 1}

  ############
  # For Board
  ############
  # status 0 is newly established board and 1 is active game.
  def any_active_game
    games.where("status = 1").any?
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
  def reset #(cells)
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
    grid.map { |row| row.map { |cell| "[#{cell.value.empty? ? "_" : cell.value}]" }.join("") }
  end

  def draw_grid
    puts "*" * self.width * 3
    label = (1..self.width).map { |n| "(#{n})" }.join("")
    puts label
    puts console_grid.join("\n")
    puts "*" * self.width * 3
  end

  def add_to_col(col, value)
    if available_cells_by_col(col).size > 0
      next_available_cell(col).set_value(value)
    else
      false
    end
  end

  def game_over
    winner, coords = detect_win
    return {winner: [winner, coords]} if winner
    return {tie: "The game ended in a tie"} if tie?
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
      [player_colors.first, coords]
    else
      [nil, nil]
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
    self.cells.by_coordinates([x, y])
  end

  def clear_screen
    40.times { puts }
  end

  ###########
  # For game
  ###########
  def set_current_player(player = self.players.shuffle.first)
    self.current_player = player
    self.save
  end

  def create_players(players_arr)
    players_arr.each do |p|
      self.players << Player.create(p)
    end
    self.set_current_player
    "#{self.current_player.name} has randomly been selected as the first player"
  end

  def establish_players
    if self.players.blank? && kind == GAME_KINDS[:human_vs_human]
      create_players(players_names_from_console)
    end
  end

  def players_names_from_console
    puts "Please enter two comma-separated names for players X,O :"
    hm = STDIN.gets.chomp
    puts "You entered #{hm}"
    ps = hm.split(',')
    puts "player X = #{ps[0]} and player O = #{ps[1]}"
    [{color: "X", name: ps[0]}, {color: "O", name: ps[1]}]
  end

  def solicit_move
    "#{current_player.name}: Select between columns 1 and 7 to make your move"
  end

  def yellow_player
    players.find_by_color('X').name
  end

  def red_player
    players.find_by_color('O').name
  end

  def switch_players
    set_current_player(players.without(current_player).first)
  end

  def get_move(human_move = STDIN.gets.chomp)
    human_move.to_i
  end

  def game_over_message
    over = board.game_over
    return nil unless over
    if over[:winner]
      winner = players.find_by_color(over[:winner].first).name rescue over[:winner].first
      return "#{winner} won! Winning coordinates #{over[:winner].last}"
    end
    return over[:tie] if over[:tie]
  end

  def play
    ActiveRecord::Base.logger.silence do
      puts "#{current_player.name} has randomly been selected as the first player"
      self.update_attribute(:status, STATUS[:started])
      good_play = true
      while good_play
        clear_screen
        draw_players
        board.draw_grid
        puts ""
        puts solicit_move
        col = get_move
        good_play = board.add_to_col(col, current_player.color)
        message = game_over_message
        if message
          puts message
          self.update_attribute(:status, STATUS[:ended])
          draw_players
          board.draw_grid
          return
        else
          switch_players
        end
        clear_screen
      end
    end
  end

  def draw_players
    puts "*" * self.board.width * 3
    puts "Connect4 on Rails"
    puts "-" * self.board.width * 3
    puts "Players:"
    self.players.map { |p| puts "#{p.color} = #{p.name}" }
  end
end
