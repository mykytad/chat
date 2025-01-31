require "rails_helper"
require "shared_methods"

RSpec.feature "messages pages", type: :feature do
  before do
    user_for_chat
    log_in(test_user)
    visit root_path
  end

  it "send messages" do
    click_button "Start"

    expect(body).to have_content "Foo"

    fill_in :message_body, with: "Hi, Foo"
    within(".col-auto.col-1") do
      click_button "Send"
    end

    expect(body).to have_content "Hi, Foo"
  end
end
