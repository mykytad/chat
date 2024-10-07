class AddRepliedToIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :replied_to_id, :integer
  end
end
