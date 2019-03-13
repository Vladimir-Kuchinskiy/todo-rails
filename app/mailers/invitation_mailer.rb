# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def send_invitation
    @invitation = params[:invitation]
    mail(to: @invitation.receiver.email, subject: 'New invitation to a Team')
  end
end
