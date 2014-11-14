require 'rails_helper'
require 'subscribem/testing_support/factories/account_factory'

feature "Account scoping" do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }
  before do
    Post.scoped_to(account_a).create(:title => "Account A's Post")
    Post.scoped_to(account_b).create(:title => "Account B's Post")
  end

  scenario "display only account A's records" do
    visit posts_url(:subdomain => account_a.subdomain)
    expect(page).to have_content("Account A's Post")
    expect(page).to_not have_content("Account B's Post")
  end

  scenario "display only account B's records" do
    visit posts_url(:subdomain => account_b.subdomain)
    expect(page).to have_content("Account B's Post")
    expect(page).to_not have_content("Account A's Post")
  end
end
