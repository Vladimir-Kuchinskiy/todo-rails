# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < ApplicationController
      def show
        json_response(ProfileSerializer.new(current_user.profile))
      end

      def update
        current_user.profile.update!(profile_attributes)
        json_response(ProfileSerializer.new(current_user.profile))
      end

      private

      def profile_attributes
        params.permit(:first_name, :last_name, :gender, :avatar)
      end
    end
  end
end
