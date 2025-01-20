class AvatarGenerator
  def self.generate(user)
    avatar_hash = Digest::SHA1.hexdigest(user.id.to_s)
    file_path = Rails.root.join("public", "images", "#{avatar_hash}.png")

    unless File.exist?(file_path)
      img = Avatarly.generate_avatar(user.name, size: 40)
      File.open(file_path, 'wb') { |f| f.write(img) }
    end

    avatar_hash
  end
end
