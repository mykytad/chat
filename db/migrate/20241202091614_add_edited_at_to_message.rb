class AddEditedAtToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :edited_at, :datetime, default: Time.current, null: false
  end
end
