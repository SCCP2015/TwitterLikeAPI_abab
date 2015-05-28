require 'data_mapper'
require 'digest/md5'

# Model class
class User
  include DataMapper::Resource

  property :id, Serial
  #  Names of twitterlike's users are not duplicated.
  property :name, String, unique: true
  property :create_time, DateTime

  has n, :user_sessions
end

# Model class
class UserSession
  include DataMapper::Resource

  property :id, Serial
  property :remember_token, String
  property :create_time, DateTime

  belongs_to :user
end

DataMapper.finalize
