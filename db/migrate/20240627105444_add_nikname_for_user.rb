class AddNiknameForUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nikname, :string
    add_index(:users, [:nikname], unique: true)
  end
end
