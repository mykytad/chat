class AddImagesToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :images, :string
  end
end
