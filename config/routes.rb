Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :board
  post 'move', to: 'board#move', as: :move
  get 'board/:id/game/:game_id', to: 'board#show', as: :show_game
  get 'move/:game_id', to: 'board#move', as: :get_move
  root 'board#index'
end
