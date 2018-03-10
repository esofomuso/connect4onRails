module BoardHelper
  def play_game
    notice = message = ""
    game.update_attribute(:status, Game::STATUS[:started])
    if params[:reset_game]
      game.reset
      game.set_current_player
      notice = "Game reset and #{game.current_player.name} has randomly been selected as the first player."
      message = game.solicit_move
    else
      board.add_to_col(params[:col].to_i, current_player.color)
      message = game.game_over_message
      if message
        game.update_attribute(:status, Game::STATUS[:ended])
      else
        game.switch_players
        message = game.solicit_move
      end
    end
    [message, notice]
  end
end
