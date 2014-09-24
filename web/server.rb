require_relative '../lib/ping_pong_tournament.rb'

require 'sinatra'
require 'sinatra/reloader'

class PingPongTournament::Server < Sinatra::Application

  get '/index' do
    

  end

  get '/tournament' do


  end

  run! if __FILE__ == $0

end


