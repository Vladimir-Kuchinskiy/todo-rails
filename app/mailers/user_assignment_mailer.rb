# frozen_string_literal: true

class UserAssignmentMailer < ApplicationMailer
  def notify_assignment
    @assigner = params[:assigner]
    @user_card = params[:user_card]
    mail(to: @user_card.user.email, subject: 'New assignment to a card')
  end

  def notify_unassignment
    @unassigner = params[:unassigner]
    @user = params[:user]
    @card = params[:card]
    mail(to: @user.email, subject: 'Unassignment from a card')
  end
end
