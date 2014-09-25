require_relative '../lib/ping_pong_tournament.rb'
require_relative '../config/environments.rb'
<<<<<<< HEAD

=======
#require 'active_record'
>>>>>>> master
require 'sinatra'
require 'sinatra/reloader'

class PingPongTournament::Server < Sinatra::Application

  set :bind, '0.0.0.0'

  get '/' do
    erb :index
  end

  get '/tournament' do
    erb :tournament
  end

  #Create a new player
  get '/create' do
    erb :new_player
  end

  #Player form post
  post '/create' do
    name = params['player-name']
    player = PingPongTournament::Player.create(name: name)


  end


  get '/create_tournament' do
    erb :eight_player_tournament
  end

  #Tournament form post
  post '/create_tournament' do

  end



  run! if __FILE__ == $0

end


