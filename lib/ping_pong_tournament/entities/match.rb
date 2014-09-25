module PingPongTournament
  class Match < ActiveRecord::Base
    has_many :players
  end
end