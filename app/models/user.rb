class User < ActiveRecord::Base
	validates :username, :password, {presence: true, length: { in: 3..20 } }
	# validates :username, uniqueness: true
end
