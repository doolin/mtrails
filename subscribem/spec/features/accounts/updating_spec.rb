require 'rails_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'subscribem/testing_support/authentication_helpers'

feature "Accounts" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let(:account) { FactoryGirl.create(:account) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  context "as the account owner" do
    before do
      sign_in_as(:user => account.owner, :account => account)
    end

    scenario "updating an account" do
      visit root_url
      click_link "Edit Account"
      fill_in "Name", :with => "A new name"
      click_button "Update Account"
      expect(page).to have_content("Account updated successfully.")
      expect(account.reload.name).to eq("A new name")
    end

    scenario "updating an account with invalid attributes" do
      visit root_url
      click_link "Edit Account"
      fill_in "Name", :with => ""
      click_button "Update Account"
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Account could not be updated.")
    end

    context "with plans" do
      let!(:starter_plan) do
        Subscribem::Plan.create(
          :name  => "Starter",
          :price => 9.95,
          :braintree_id => "starter"
        )
      end
      let!(:extreme_plan) do
        Subscribem::Plan.create(
          :name  => "Extreme",
          :price => 19.95,
          :braintree_id => "extreme"
        )
      end

      before do
        account.update_column(:plan_id, starter_plan.id)
      end

      scenario "updating an account's plan" do
        query_string = Rack::Utils.build_query(
          :plan_id => extreme_plan.id,
          :http_status => 200,
          :id => "a_fake_id",
          :kind => "create_customer",
          :hash => "05738fa783d7fd49650c61251bf227053eea1eb2"
        )
        mock_transparent_redirect_response = double(:success? => true)
        expect(Braintree::TransparentRedirect).to receive(:confirm).
          with(query_string).
          and_return(mock_transparent_redirect_response)
        visit root_url
        click_link "Edit Account"
        select "Extreme", :from => 'Plan'
        click_button "Update Account"
        expect(page).to have_content("Account updated successfully.")
        # expect(account.reload.plan).to eq(extreme_plan)
        plan_url = subscribem.plan_account_url(
          plan_id: extreme_plan.id,
          subdomain: account.subdomain)
        expect(page.current_url).to eq(plan_url)
        expect(page).to have_content("You are changing to the 'Extreme' plan.")
        expect(page).to have_content("This plan costs $19.95 per month.")
        fill_in "Credit card number", with: "4111111111111111"
        fill_in "Name on card", with: "Dummy user"
        future_date = "#{Time.now.month + 1}/#{Time.now.year + 1}"
        fill_in "Expiration date", with: future_date
        fill_in "CVV", with: "123"
        click_button "Change plan"
        expect(page).to have_content("You have switched to the 'Extreme' plan.")
        expect(page.current_url).to eq(root_url)
      end
    end
  end

  context "as a user" do
    before do
      user = FactoryGirl.create(:user)
      sign_in_as(:user => user, :account => account)
    end

    scenario "cannot edit an account's information" do
      visit subscribem.account_url(:subdomain => account.subdomain)
      expect(page).to have_content("You are not allowed to do that.")
    end
  end
end
