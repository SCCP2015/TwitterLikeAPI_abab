require 'data_mapper'

# Model class
class User
  include DataMapper::Resource

  property :id, Serial
  #  Names of twitterlike's users are not duplicated.
  property :name, String, unique: true
  property :password_hash, Text
  property :password_salt, Text
  property :create_time, DateTime

  has n, :user_sessions
  def to_hash
    {
      id: id, name: name, password_hash: password_hash,
      password_salt: password_salt, create_time: create_time
    }
  end
end

# Model class
class UserSession
  include DataMapper::Resource

  property :id, Serial
  property :token_hash, Text, unique: true
  property :create_time, DateTime

  belongs_to :user
end

# Model class
class Tweet
  include DataMapper::Resource

  property :id, Serial
  property :message, Text
  property :create_time, DateTime

  belongs_to :user
end

DataMapper.finalize
