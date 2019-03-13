# frozen_string_literal: true

class ProcessInviteResponse
  def self.call(params)
    new(params).call
  end

  def call
    invitation = Invitation.find_by!(id: params[:id])
    UserTeam.create!(team_id: invitation.team_id, user_id: invitation.receiver_id) if true?(params[:desigion])
    invitation.destroy
  end

  private

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def true?(obj)
    obj.to_s == 'true'
  end
end
