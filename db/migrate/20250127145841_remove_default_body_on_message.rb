class RemoveDefaultBodyOnMessage < ActiveRecord::Migration[7.0]
  def change
    change_column_default :messages, :body, nil
  end
end
