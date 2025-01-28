class RemoveNullOnMessage < ActiveRecord::Migration[7.0]
  def change
    change_column :messages, :body, :string, null: true
  end
end
