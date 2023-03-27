class User < ApplicationRecord
  has_secure_password

  belongs_to :organization

  validates_presence_of :email, :first_name, :last_name
  validates :password, length: { minimum: 8 }, if: :password_digest_changed?
  validates_uniqueness_of :email

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    first_name[0] + last_name[0]
  end
end