namespace :game do
  desc "Play Connect4"
  # Using the standard 7 x 6 board
  # In console  rails game:human_vs_human
  task human_vs_human: :environment do
    Board.play_in_console
  end
end
