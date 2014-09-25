require_relative '../lib/ping_pong_tournament.rb'

require 'sinatra'
require 'sinatra/reloader'

class PingPongTournament::Server < Sinatra::Application

  get '/' do
    erb :index

  end

  get '/tournament' do


  end

  post '' do

  end
  
  #Post sent by the form contains all the names
  post '' do
    names =[]
    params.each do |k,v|
      names << v
  end

end


  run! if __FILE__ == $0

end


