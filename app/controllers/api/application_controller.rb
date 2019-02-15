# frozen_string_literal: true

module Api
  class ApplicationController < ::ApplicationController
    include ::Response
    include ::ExceptionHandler
  end
end
