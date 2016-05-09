class Person < ApplicationRecord
  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 10}
  validates :surname, presence: true, length: { maximum: 20}
  validates :mail, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence:true, length: { minimum: 6}
  before_save { self.mail = mail.downcase }
  has_secure_password

  def Person.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = Person.new_token
    update_attribute( :remember_digest, Person.digest(remember_token))
  end

  def Person.new_token
    SecureRandom.urlsafe_base64
  end

  def forget
    update_attribute(:remember_digest, nil)
  end


  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
