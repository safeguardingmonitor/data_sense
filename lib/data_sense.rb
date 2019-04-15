require "data_sense/version"
require "data_sense/api"
require "data_sense/base"

require "data_sense/contact"
require "data_sense/demographic"
require "data_sense/school"
require "data_sense/student"
require "data_sense/org"
require "data_sense/user"

require "faraday"
require "active_support/all"

module DataSense
  class Error < StandardError; end
  class ApiError < DataSense::Error; end
  class AuthorizationError < DataSense::Error; end
  class ConnectionError < DataSense::Error; end
  class InvalidSubscriptionKeyError < DataSense::Error; end
  class NotFoundError < DataSense::Error; end
  class ParserError < DataSense::Error; end
end
