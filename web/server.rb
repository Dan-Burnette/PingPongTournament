require_relative '../lib/ping_pong_tournament.rb'

require 'sinatra'
require 'sinatra/reloader'

class PingPongTournament::Server < Sinatra::Application

  get '/index' do
    

  end

  get '/tournament' do


  end

  get '/new_player' do

  erb: :new_player 
  end

  post '/create_player' do
  	# params["player-name"]
  	# feed names of player to table players
  end

  post '/create_tournament' do 
  end

  run! if __FILE__ == $0

end


