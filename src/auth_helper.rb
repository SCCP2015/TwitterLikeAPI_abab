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
    return nil if User.first(name: name)
    salt = BCrypt::Engine.generate_salt
    hash = to_hash_with_salt(password, salt)
    User.create(
      name: name, password_hash: hash, password_salt:
         salt, create_time: Time.now)
  end

  def delete_session(user_id)
    old_session = UserSession.first(user_id: user_id)
    old_session.destroy unless old_session.nil?
  end

  # authenticate by name and password (when a user signin)
  def authenticate(name, password)
    user = User.first(name: name)
    return nil if user.nil?
    is_password =
      user.password_hash == to_hash_with_salt(password, user.password_salt)
    return nil unless user && is_password
    user
  end

  # authenticate by token (when a user access APIs)
  def authenticate_by_token(token)
    UserSession.first(token_hash: to_hash(token))
  end

  def find_user(name, password)
    return nil if name.nil? || password.nil?
    authenticate(name, password)
  end

  def find_user_by_token(token)
    return nil if token.nil?
    user_session = authenticate_by_token(token)
    return nil unless user_session
    User.get(user_session.user_id)
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
