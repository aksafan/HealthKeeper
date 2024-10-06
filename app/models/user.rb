class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :health_records, dependent: :destroy
  has_many :lab_tests, dependent: :destroy
  has_many :measurements, dependent: :destroy

  resourcify

  validates :email, presence: true, uniqueness: true, email: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
