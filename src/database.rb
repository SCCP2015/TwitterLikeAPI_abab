# coding: utf-8
require 'singleton'

# Databaselike System
class Database
  include Singleton

  FILE = 'data'

  def read
    if File.exist?(FILE)
      File.read(FILE)
    else
      ''
    end
  end

  def write(word)
    if File.exist?(FILE)
      data = File.read(FILE)
      new_data = data + word + "\n"
      File.write(FILE, new_data)
      new_data
    else
      new_data = word + "\n"
      File.write(FILE, new_data)
      new_data
    end
  end

  def update(word)
    new_data = word + "\n"
    File.write(FILE, new_data)
    new_data
  end

  def delete
    File.write(FILE, '')
    ''
  end
end
