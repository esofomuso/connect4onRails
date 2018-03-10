class BoardController < ApplicationController
  expose(:board) { params[:id] ? Board.find_by_id(params[:id]) : Board.establish } #{ @board || game.board }
  expose(:game) { @game || Game.find_by_id_and_board_id(params[:game_id], board.id) }
  expose(:current_player) { game.current_player unless game.blank? }
  expose(:next_player) { curent_game.next_player }
  expose(:grid) { board.grid }
  expose(:message) { @message }

  def index
  end

  def create
    @game ||= Game.establish(board)
    flash[:message] = @message = game.create_players([{color: "X", name: params[:player1]}, {color: "O", name: params[:player2]}])
    redirect_to "/board/#{board.id}/game/#{@game.id}"
  end

  def show
    redirect_to "/" and return if game.blank?
    @message = message || flash[:message]
  end

  def move
    @message, @notice = helpers.play_game
    respond_to do |f|
      f.js
    end
  end
end
