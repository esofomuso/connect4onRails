class Game < ApplicationRecord
  STATUS = {new: 0, started: 1, ended: 2}
  GAME_KINDS = {human_vs_human: 0, human_vs_computer: 1}

  has_many :players, class_name: "Player"
  belongs_to :current_player, class_name: "Player", optional: true
  belongs_to :board

  attr_accessor :kind

  def self.establish(board, kind = GAME_KINDS[:human_vs_human])
    g = create(board_id: board.id, status: STATUS[:new])
    g.kind = kind
    g
  end

  def reset
    board.reset
    self.update_attribute(:status, STATUS[:new])
  end

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
    hm = gets.chomp
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

  def get_move(human_move = gets.chomp)
    human_move.to_i
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
        message = board.game_over_message
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

  private

  def draw_players
    puts "*" * self.board.width * 3
    puts "Connect4 on Rails"
    puts "-" * self.board.width * 3
    puts "Players:"
    puts "X = #{self.players.where(color: 'X').first.name}"
    puts "O = #{self.players.where(color: 'O').first.name}"
  end

  def clear_screen
    40.times { puts }
  end
end
