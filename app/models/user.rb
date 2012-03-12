class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: { in: 4..16 }
  has_secure_password
end
