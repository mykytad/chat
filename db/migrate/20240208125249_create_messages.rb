class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :body,              null: false, default: ""
      t.integer :user_id,          null: false, default: ""
      t.timestamps
    end
  end
end
