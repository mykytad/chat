class AddLastMessageForDialogue < ActiveRecord::Migration[7.0]
  def change
    add_column :dialogues, :last_message, :string
  end
end
