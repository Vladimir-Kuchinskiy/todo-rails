# frozen_string_literal: true

module Api
  module V1
    class TeamsController < ApplicationController
      before_action :set_team, only: %i[show update destroy]

      def index
        json_response(TeamSerializer.new(current_user.teams))
      end

      def create
        @team = current_user.create_team(team_params)
        json_response(TeamSerializer.new(@team), :created)
      end

      def show
        json_response(TeamSerializer.new(@team, include: %i[boards users]))
      end

      def update
        @team.update(team_params)
        head :no_content
      end

      def destroy
        @team.destroy
        head :no_content
      end

      private

      def set_team
        @team = current_user.teams.find(params[:id])
      end

      def team_params
        params.permit(:name)
      end
    end
  end
end