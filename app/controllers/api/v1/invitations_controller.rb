# frozen_string_literal: true

module Api
  module V1
    class InvitationsController < ApplicationController
      def index
        json_response(InvitationSerializer.new(current_user.received_invitations))
      end

      def create
        invitation = current_user.create_invitation(params)
        InvitationMailer.with(invitation: invitation).send_invitation.deliver_later
        head :created
      end

      def destroy
        deleted_invitation = ProcessInviteResponse.call(params)
        json_response(InvitationSerializer.new(deleted_invitation, include: %i[team]))
      end
    end
  end
end
