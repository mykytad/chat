require "rails_helper"
require "shared_methods"

RSpec.feature "static pages", type: :feature do
  before do
    user_for_chat
    log_in(test_user)
    visit root_path
  end

  it "visit dialogues page" do
    click_link "All dialogues"

    expect(body).to have_content "All dialogue:"
    expect(body).to have_content "Select users to chat"
    expect(body).to have_content "Foo"
  end

  it "start dialogue" do
    click_link "All dialogues"
    click_link "Foo"
    click_button "Confirm"

    expect(body).to have_content "Foo"
  end

  it "send messages" do
    click_link "All dialogues"
    click_link "Foo"
    click_button "Confirm"
    fill_in :message_body, with: "Hi, Foo"
    click_button "Send"
    save_and_open_page
    expect(body).to have_content "Tomas:"
    expect(body).to have_content "- Hi, Foo"
  end
end
