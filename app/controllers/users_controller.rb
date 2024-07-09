class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @avatar = Digest::SHA1.hexdigest(@user.id.to_s) # хэш имени аватара
    file_path = "public/images/#{@avatar}.png" # путь к файлу аватара
    file = File.exists?(file_path)

    if file == false
      img = Avatarly.generate_avatar(@user.name, opts = { size: 40 })
      File.open(file_path, 'wb') do |f|
        f.write(img)
      end
    end
  end
end
