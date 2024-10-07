class AddPinedAttToDialogues < ActiveRecord::Migration[7.0]
  def change
    add_column :dialogues, :pined_at, :datetime
  end
end
