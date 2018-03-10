require 'rails_helper'

RSpec.describe BoardController, type: :controller do
  let (:board) { Board.create(width: 7, height: 6) }
  let (:game) { Game.create(board_id: board.id) }
  let (:player1) { Player.create(game_id: game.id, color: 'X', name: "Jane") }
  let (:player2) { Player.create(game_id: game.id, color: 'O', name: "Sue") }
  describe "POST #create" do
    before do
      board
      game
      post :create, body: {id: board.id, player1: player1.name, player2: player2.name}
    end
    it "establishes a game and creates players" do
      expect(Game).to respond_to(:establish) { game }
      expect(game).to respond_to(:create_players)
    end
    it "redirects to show view" do
      expect(response).to redirect_to "/board/#{board.id}/game/#{board.games.last.id}"
    end
  end

  describe "GET #show" do
    before do
      board
    end
    it "renders the show template" do
      game
      get :show, params: {id: board.id, game_id: board.games.first.id}
      #   get "/board/#{board.id}/game/#{board.games.first.id}"
      expect(response.status).to eq(200)
    end
    it "redirects to index if there is no game" do
      get :show, params: {id: board.id}
      expect(response.status).to eq(302)
    end
  end

  describe "GET #move" do
    before do
      board
      game
      player1
      player2
      game.set_current_player([player1, player2].shuffle.first)
    end
    it "plays the game" do
      post :move, params: {id: board.id, game_id: board.games.first.id, col: (1..7).to_a.shuffle.first, format: :js}
      expect(response.status).to eq(200)
    end
  end
end
