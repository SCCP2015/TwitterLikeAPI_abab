# coding: utf-8
require 'digest/md5'

# Session Helper Module
module SessionsHelper
  def new_remember_token
    SecureRandom.urlsafe_base64
  end

  def encrypt(str)
    # create ramdom string for every user
    salt = 'salt'
    Digest::MD5.hexdigest(str + salt)
  end
end
