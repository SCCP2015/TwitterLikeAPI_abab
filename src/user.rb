require 'data_mapper'
require 'digest/md5'

# Model class
class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, unique: true
  property :remember_token, String

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(str)
    # create ramdom string for every user
    salt = 'salt'
    Digest::MD5.hexdigest(str + salt)
  end
end

DataMapper.finalize
