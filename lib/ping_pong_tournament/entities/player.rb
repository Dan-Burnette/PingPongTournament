module PingPongTournament
  class Player < ActiveRecord::Base
    has_many :matches
  end
end