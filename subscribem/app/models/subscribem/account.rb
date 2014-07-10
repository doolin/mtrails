module Subscribem
  class Account < ActiveRecord::Base
    belongs_to :owner, class_name: Subscribem::User
    accepted_nested_attributes_for :owner
  end
end
