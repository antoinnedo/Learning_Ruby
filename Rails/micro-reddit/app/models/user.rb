class User < ApplicationRecord
  has_many :posts

  has_secure_password

  before_save { self.username = username.downcase }

  validates  :username, presence: true,
            # Ensures the `username` is unique across all users, ignoring case.
            # The `before_save` callback helps enforce this consistently.
            uniqueness: { case_sensitive: false },
            # Defines the minimum and maximum length for the username.
            length: { minimum: 3, maximum: 25 }
end
