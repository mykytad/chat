class User < ApplicationRecord
  has_many :messages
  has_many :dialogues
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
  has_many :notifications_mentions, as: :record, dependent: :destroy, class_name: "Noticed::Event"

  # validates :nickname, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
