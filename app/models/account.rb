class Account < ApplicationRecord
    has_secure_password
  
    # Add validations as necessary
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
end
  