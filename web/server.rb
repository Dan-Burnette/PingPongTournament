require_relative '../lib/ping_pong_tournament.rb'
require_relative '../config/environments.rb'

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'

class PingPongTournament::Server < Sinatra::Application

  set :bind, '0.0.0.0'

  get '/' do
    @tournaments = PingPongTournament::Tournament.all
    erb :index
  end

  get '/select_stats' do
    @players = PingPongTournament::Player.all
    erb :stats, :locals => {matches: false}
  end

  get '/tournament_winner' do
     winner = PingPongTournament::Tournament.last.player_id
     winner = PingPongTournament::Player.find(winner)
     erb :tournament_winner, :locals => {winner: winner}
   end

  get '/tournament' do
    @tournament = PingPongTournament::Tournament.find(params['id'])
    @matches = PingPongTournament::Match.where(tournament_id: @tournament.id)
    if @matches.size == 7
      @players = []
      @matches.each do |m|
        @players.push(PingPongTournament::Player.find(m.player1).name)
        @players.push(PingPongTournament::Player.find(m.player2).name)
        @players.push(PingPongTournament::Player.find(m.winner).name)
      end
      erb :tournament_archive
    else
      redirect to '/'
    end
  end

  get '/champion' do
   tournaments = PingPongTournament::Tournament.where.not(player_id: nil)
   winners= []
   tournaments.each do |tournament|
     id = tournament.player_id
     winners.push(PingPongTournament::Player.find(id))
   end 
   winners = winners.reverse
   erb :champion, :locals => {tournaments: tournaments,
                             winners: winners}
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

    if (players.length != 8)
      error = "Error: You did not enter eight players"
      erb :error, :locals => {error: error}
  
    else
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


  end

  post '/stats' do
    @players = PingPongTournament::Player.all
    player_name = params['player']
    id = PingPongTournament::Player.find_by(name: player_name).id
    matches = PingPongTournament::Match.where("player1 = ? or player2 = ?", id, id)
    match_wins = matches.select{|match| match.winner == id }.length
    tournament_wins = PingPongTournament::Tournament.where("player_id = ?", id).length
    matches_played = matches.length
    win_percentage = (match_wins.to_f / matches_played.to_f * 100.0).to_i
    erb :stats, :locals => {matches: matches_played, player: player_name, wins: match_wins, twins: tournament_wins, wp: win_percentage}
  end

  post '/submit-tournament' do
    puts params
    tournamentid = -1
    if (params['round'] == '1') 
      params.each do |k,v|
        if (k == 'round')
        #don't do anything
        else
          player = PingPongTournament::Player.find_by(name: k)
          id = player.id
          match = PingPongTournament::Match.find_by(id: v)
          tournamentid = match.tournament_id
          match.update(winner: id)
        end
      end
      #make matches for nxt round
      players = params.keys
      player1 = PingPongTournament::Player.find_by(name: players[1])
      player2 = PingPongTournament::Player.find_by(name: players[2])
      player3 = PingPongTournament::Player.find_by(name: players[3])
      player4 = PingPongTournament::Player.find_by(name: players[4])
      match1 = PingPongTournament::Match.create(player1: player1.id , player2: player2.id, tournament_id: tournamentid)
      match2 = PingPongTournament::Match.create(player1: player3.id , player2: player4.id, tournament_id: tournamentid)
    end
  
    if (params['round'] == '2')
      matches = PingPongTournament::Match.last(2)
      player1 = PingPongTournament::Player.find_by(name: params['0'])
      player2 = PingPongTournament::Player.find_by(name: params['1'])
      matches[0].update(winner: player1.id)
      matches[1].update(winner: player2.id)
      tournamentid = matches[0].tournament_id
      new_match = PingPongTournament::Match.create(player1: player1.id, player2: player2.id, tournament_id: tournamentid)
    end
      
    if (params['round'] == '3')
      match = PingPongTournament::Match.last
      player = PingPongTournament::Player.find_by(name: params['0'])
      match.update(winner: player.id)
      tournament = PingPongTournament::Tournament.find(match.tournament_id)
      tournament.update(player_id: player.id)

      erb :tournament_winner, :locals => {winner: player}
    end

      
  end

  run! if __FILE__ == $0

end


