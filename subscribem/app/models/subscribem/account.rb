module Subscribem
  class Account < ActiveRecord::Base

    belongs_to :owner, class_name: Subscribem::User
    accepts_nested_attributes_for :owner

    EXCLUDED_SUBDOMAINS = %w(admin)

    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end

    validates :subdomain, presence: true, uniqueness: true
    validates :subdomain, format: {
      with: /\A[\w\-]+\z/i,
      message: "is not allowed. Please choose another subdomain."
    }
    validates :subdomain, exclusion: {
      in: EXCLUDED_SUBDOMAINS,
      message: "is not allowed. Please choose another subdomain."
    }


  end
end
