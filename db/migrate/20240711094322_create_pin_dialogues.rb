class CreatePinDialogues < ActiveRecord::Migration[7.0]
  def change
    create_table :pin_dialogues do |t|
      t.integer :user_id,          null: false, default: ""
      t.integer :dialogue_id,      null: false, default: ""
      t.timestamps
    end
  end
end
