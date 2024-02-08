require "rails_helper"

RSpec.feature "static pages", type: :feature do
  before do
    visit root_path
  end

  it "visit contacs pages" do
    click_link :page_contact

    expect(body).to have_content "Contacts"
  end

  it "visit about pages " do
    click_link "About"

    expect(body).to have_content "About"
  end
end