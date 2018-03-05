# A simple Connect 4 game on Rails

Curruntly can play in Rails console using : Board.play_in_console

## Ruby version

2.4.2

## Rails Version

5.1.5

## Setup

After  checking out project, Run :

Bundle

rails db:migrate


## Still to do 

Web Version
Make it Run outside of Rails console
Include a simple AI to play Human Vs. Computer

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

## Project Guidelines
- Level 1: Build a playable game of Connect 4 with 2 players, a command line interface being fine.  Should have player moves, win detection logic, tie detection, etc.  
- Level 2: Implement a standard “AI” for the computer player.  A standard computer opponent should block a human from winning when able to, but plays more ad hoc and does not operate with an advanced strategy.
- Level 3:  Make it playable online (Heroku or similar) with a SPA web interface, games persisting to a database,  etc.

##Inspired by:
[Tic Tac Toe on Rails] (https://github.com/MrPowers/tic_tac_toe)
[Connect Four on Rails] (https://github.com/buwilliams/connect-four)


