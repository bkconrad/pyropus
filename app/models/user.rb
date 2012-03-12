class User < ActiveRecord::Base
  validate :name, presence: true, uniqueness: true
  has_secure_password
end
