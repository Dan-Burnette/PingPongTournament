require_relative '../lib/ping_pong_tournament.rb'

require 'sinatra'
require 'sinatra/reloader'

class PingPongTournament::Server < Sinatra::Application

  get '/' do
    erb :index

  end

  get '/tournament' do
    erb :tournament

  end

  #Player form post
  post '/create' do
    name = params['player-name']
    player = PingPongTournament::Player.create(name: name)
  end

  #Tournament form post
  post 'create_tournament' do
  
  end



  run! if __FILE__ == $0

end


