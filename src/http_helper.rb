# coding: utf-8

# Auth Helper Module
module HttpHelper
  def bad_response(message)
    status 400
    json(error: message)
  end
end
