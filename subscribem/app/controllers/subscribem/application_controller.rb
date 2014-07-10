module Subscribem
  class ApplicationController < ActionController::Base
    def current_account
      if user_signed_in?
        @current_account ||= begin
          account_id = env["warden"].user(scope: :account)
          Subscribem::Account.find account_id
        end
      end
    end
    helper_method :current_account

  end
end
