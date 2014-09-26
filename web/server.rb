require_relative '../lib/ping_pong_tournament.rb'
require_relative '../config/environments.rb'

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'

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
    if name.strip == ""
      redirect to '/'
    end
    player = PingPongTournament::Player.create(name: name)
    redirect to '/create'
  end

  get '/create_tournament' do
    @players = PingPongTournament::Player.all
    erb :eight_player_tournament
  end

  post '/create_tournament' do
    players = params['players']
    tourney_name = params['tourney_name']
    tournament = PingPongTournament::Tournament.create(name: tourney_name, num_players: players.length)
    while players.size > 0
      player1 = players.delete_at(rand(players.length))
      player2 = players.delete_at(rand(players.length))
      player1 = PingPongTournament::Player.find_by(name: player1)
      player2 = PingPongTournament::Player.find_by(name: player2)
      PingPongTournament::Match.create(player1: player1.id, player2: player2.id, tournament_id: tournament.id)
    end
    matches = PingPongTournament::Match.where(tournament_id: tournament.id)
    players = []
    matches.each do |m|
      players.push(PingPongTournament::Player.find(m.player1).name)
      players.push(PingPongTournament::Player.find(m.player2).name)
    end

    erb :tournament, :locals => {matches: matches,
                                tournament: tournament,
                                players: players}
  end

  post '/submit-tournament' do
    puts params

      params.each do |k,v|
        player = PingPongTournament::Player.find_by(name: k)
        id = player.id
        match = PingPongTournament::Match.find_by(id: v)
        match.update(winner: id)

        #if params.length ==1, that match is the final match; that winner id is the tournament winner
        #Need to set that player id to the tournament winner
        if (params.length == 1)
          #TODO
        end

      end
  end

  run! if __FILE__ == $0

end


