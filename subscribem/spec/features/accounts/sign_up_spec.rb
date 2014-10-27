require 'rails_helper'

feature "Accounts" do
  scenario "creating an account" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in "Name", with: "Test"
    click_button "Create Account"
    success_message = "successfully"
    expect(page).to have_content(success_message)
  end
end
