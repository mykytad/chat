require "rails_helper"
require "shared_methods"

RSpec.feature "messages pages", type: :feature do
  before do
    user_for_chat
    log_in(test_user)
    visit root_path
    click_link :dialogues_link
  end

  it "visit dialogues page" do
    expect(body).to have_content "Chat with"
    expect(body).to have_content "All users"
    expect(body).to have_content "Foo"
  end

  it "start dialogue" do
    click_button "Start dialogue"

    expect(body).to have_content "Foo"
  end

  # it "send messages" do
  #   click_button "Start dialogue"

  #   expect(body).to have_content "Foo"

  #   fill_in :message_body, with: "Hi, Foo"
  #   click_button "Send"

  #   expect(body).to have_content "Hi, Foo"
  # end
end
