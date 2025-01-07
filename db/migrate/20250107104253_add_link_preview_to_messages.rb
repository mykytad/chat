class AddLinkPreviewToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :link_title, :string
    add_column :messages, :link_description, :text
    add_column :messages, :link_image, :string
    add_column :messages, :link_url, :string
  end
end
