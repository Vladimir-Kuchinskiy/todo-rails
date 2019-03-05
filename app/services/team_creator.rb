# frozen_string_literal: true

class TeamCreator
  def self.call(params, current_user)
    new(params, current_user).call
  end

  def call
    team = nil
    current_user.transaction do
      team = Team.create!(name: params[:name])
      user_team = UserTeam.new(user_id: current_user.id, team_id: team.id)
      user_team.add_role('creator')
      user_team.save
    end
    team
  end

  private

  attr_reader :params, :current_user

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end
end
