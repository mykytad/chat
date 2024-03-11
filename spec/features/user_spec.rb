require "rails_helper"
require "shared_methods"

RSpec.feature "create user", type: :feature do
  it "creates a new user" do
    visit new_user_registration_path
    fill_in :user_name, with: "Tom"
    fill_in :user_phone, with: "0987654321"
    fill_in :user_email, with: "tom@example.com"
    fill_in :user_password, with: "111111"
    fill_in :user_password_confirmation, with: "111111"
    click_button "Sign up"

    expect(body).to have_content "All chat"
    expect(body).to have_link :profile_link
  end

  it "profile show" do
    log_in(test_user)

    expect(body).to have_link :profile_link
    expect(body).to have_content "Chat with:"
  end
end
