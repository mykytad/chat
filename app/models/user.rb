class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  # has_many :dialogues

  has_many :sent_dialogues, class_name: "Dialogue", foreign_key: :sender_id, dependent: :destroy
  has_many :received_dialogues, class_name: "Dialogue", foreign_key: :recipient_id, dependent: :destroy

  # validates :nickname, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
