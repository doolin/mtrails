require_dependency "subscribem/application_controller"

module Subscribem
  class DashboardController < ApplicationController
    before_filter :authenticate_user!

    def index
    end
  end
end
