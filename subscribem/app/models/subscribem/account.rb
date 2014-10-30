module Subscribem
  class Account < ActiveRecord::Base
    validates :subdomain, :presence => true, :uniqueness => true
    belongs_to :owner, :class_name => "Subscribem::User"
    accepts_nested_attributes_for :owner

    EXCLUDED_SUBDOMAINS = %w(admin)
    validates_exclusion_of :subdomain, :in => EXCLUDED_SUBDOMAINS,
      :message => "is not allowed. Please choose another subdomain."
  end
end
