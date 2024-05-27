require "rails_helper"
require "shared_methods"

RSpec.feature "static pages", type: :feature do
  before do
    log_in(test_user)
    click_link :profile_link
  end

  it "visit contacs pages" do
    click_link :page_contact

    expect(body).to have_content "Contacts"
  end

  it "visit about pages " do
    click_link "About"

    expect(body).to have_content "About"
  end

  it "visit index pages " do
    click_link "MyChat"

    expect(body).to have_content "Chat with"
  end
end
