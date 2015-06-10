require "sinatra"
require "pry"
require "openssl"

enable :sessions

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get "/" do
  if session[:player_wins].nil?
    session[:player_wins] = 0
  end
  if session[:computer_wins].nil?
    session[:computer_wins] = 0
  end
  erb :index, locals: {
    session: session, end_game: end_game
    }
end

post "/" do
  comp_choice = generate_comp_choice
  outcome = result(params["choice"], comp_choice)
  win = game_wins(outcome)
  redirect '/'
end

def generate_comp_choice
%w[rock paper scissors][rand(3)]
end

def result(choice, comp_choice)
  case [choice, comp_choice]
    when ['rock', 'rock'], ['paper', 'paper'], ['scissors', 'scissors']
      ' It\'s a tie.'
    when ['rock', 'scissors'], ['paper', 'rock'], ['scissors', 'paper']
      ' You win this round!'
    when ['paper', 'scissors'], ['scissors', 'rock'], ['rock', 'paper']
      ' Computer wins this round :('
  end
end


def game_wins(win)
  if win == ' You win this round!'
    session[:player_wins] += 1
  elsif win == ' Computer wins this round :('
      session[:computer_wins] += 1
  end
end

def end_game
  if session[:player_wins] == 3
    puts "You win the game!"
    session[:player_wins] = 0
    session[:computer_wins] = 0
  elsif session[:computer] == 3
      puts "Computer wins the game :("
      session[:player_wins] = 0
      session[:computer_wins] = 0
  end
end
