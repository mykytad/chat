class User < ApplicationRecord
  has_many :messages
  has_many :dialogues
  has_many :pin_dialogues

  # validates :nikname, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
