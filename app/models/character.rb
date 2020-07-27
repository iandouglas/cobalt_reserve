class Character < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
  has_many :game_session_characters
  has_many :game_sessions, through: :game_session_characters
end
