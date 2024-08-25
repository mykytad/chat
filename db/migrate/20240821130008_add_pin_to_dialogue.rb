class AddPinToDialogue < ActiveRecord::Migration[7.0]
  def change
    add_column :dialogues, :pin_dialogue, :boolean, null: false, default: false
  end
end
