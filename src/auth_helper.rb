# coding: utf-8
require 'digest/md5'
require 'bcrypt'
require_relative 'user'

# Auth Helper Module
module AuthHelper
  def new_token
    SecureRandom.urlsafe_base64
  end

  def create_user(name, password)
    if User.first(name: name)
      nil
    else
      salt = BCrypt::Engine.generate_salt
      hash = to_hash_with_salt(password, salt)
      User.create(
        name: name, password_hash: hash, password_salt:
         salt, create_time: Time.now)
    end
  end

  # authenticate by name and password (when a user signin)
  def authenticate(name, password)
    user = User.first(name: name)
    return unless
      user && user.password_hash == to_hash_with_salt(password, user.salt)
    user
  end

  # authenticate by token (when a user access APIs)
  def authenticate_by_token(token)
    UserSession.first(token_hash: to_hash(token))
  end

  def to_hash(str)
    Digest::SHA1.hexdigest(str)
  end

  def to_hash_with_salt(str, salt)
    BCrypt::Engine.hash_secret(str, salt)
  end
end

#  +-------------------------+  isExists?   +------+
#  | Form with name and pass | -----------> | User |
#  +-------------------------+              +------+

#  +-------------+  isExists?   +-------------+  isExists?   +------+
#  | Plain token | -----------> | UserSession | -----------> | User |
#  +-------------+              +-------------+              +------+
