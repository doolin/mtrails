class Thing < ActiveRecord::Base
  def scoped_to(account)
    where(:account_id => account.id)
  end
end
