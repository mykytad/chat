require "rails_helper"
require "shared_methods"

RSpec.feature "dialogues pages", type: :feature do
  before do
    user_for_chat
    log_in(test_user)
    visit root_path
  end

  it "visit dialogues page" do
    expect(body).to have_content "All users"
    expect(body).to have_content "Foo"
  end

  describe "start and delete dialogue" do
    it "start dialogue" do
      click_button "Start"

      expect(body).to have_content "Foo"
    end

    it "delete dialogue" do
      click_button "Start"
      click_link :dialogue_delete_link

      expect(body).to have_content "All users"
    end
  end

  describe "pin and unpin dialogue" do
    it "pin dialogue" do
      click_button "Start"

      expect(body).to have_content "Foo"
      expect(body).to have_link :pin_link

      click_link :pin_link
      expect(body).to have_link :unpin_link
    end

    it "unpin dialogue" do
      click_button "Start"
      click_link :pin_link
      click_link :unpin_link

      expect(body).to have_link :pin_link
    end
  end
end
