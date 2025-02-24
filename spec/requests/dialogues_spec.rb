require 'rails_helper'

RSpec.describe DialoguesController, type: :request do
  let(:user) { create(:user) }
  let(:recipient) { create(:user) }
  let(:dialogue) { create(:dialogue, sender: user, recipient: recipient) }

  before do
    # Имитация входа пользователя
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "GET /index" do
    it "returns a successful response" do
      get dialogues_path
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get dialogues_path
      expect(response).to render_template(:index)
    end
  end

  describe "POST /create" do
    it "creates a new dialogue and redirects to the dialogue messages path" do
      expect {
        post dialogues_path, params: { recipient_id: recipient.id }
      }.to change(Dialogue, :count).by(1)
      expect(response).to redirect_to(dialogue_messages_path(Dialogue.last))
    end

    it "redirects to dialogues path with an alert on failure" do
      allow_any_instance_of(Dialogue).to receive(:save).and_return(false)
      post dialogues_path, params: { recipient_id: recipient.id }
      expect(response).to redirect_to(dialogues_path)
      expect(flash[:alert]).to eq("Something went wrong")
    end
  end

  describe "DELETE /destroy" do
    it "deletes the dialogue if the current user is the sender or recipient" do
      dialogue_to_delete = create(:dialogue, sender: user, recipient: recipient)
      expect {
        delete dialogue_path(dialogue_to_delete)
      }.to change(Dialogue, :count).by(-1)
      expect(response).to redirect_to(dialogues_path)
    end
  end

  describe "PATCH /pin" do
    it "pins the dialogue if the user has less than 10 pinned dialogues" do
      patch dialogue_pin_path(dialogue)
      dialogue.reload
      expect(dialogue.pin_dialogue).to be_truthy
      expect(response).to redirect_to(dialogue_messages_path(dialogue))
    end

    it "does not pin the dialogue if the user has 10 or more pinned dialogues" do
      10.times { create(:dialogue, sender: user, pin_dialogue: true) }
      patch dialogue_pin_path(dialogue)
      expect(response).to redirect_to(dialogues_path)
      expect(flash[:alert]).to eq('You cannot pin more than 10 dialogues.')
    end
  end

  describe "PATCH /unpin" do
    it "unpins the dialogue and redirects to the dialogue messages path" do
      dialogue.update(pin_dialogue: true)
      patch dialogue_unpin_path(dialogue)
      dialogue.reload
      expect(dialogue.pin_dialogue).to be_falsey
      expect(response).to redirect_to(dialogue_messages_path(dialogue))
    end
  end
end
