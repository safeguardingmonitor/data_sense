# frozen_string_literal: true

module DataSense
  class Api
    OAUTH_URI = "https://externalapi.datasense.com/auth/oauth2/token"
    BASE_URI = "https://externalapi.datasense.com/api/oneroster/v1p1"
    # Bearer token refreshes every hour
    BEARER_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik4tbEMwbi05REFMcXdodUhZbkhRNjNHZUNYYyIsImtpZCI6Ik4tbEMwbi05REFMcXdodUhZbkhRNjNHZUNYYyJ9.eyJhdWQiOiJjMzZkNTk3Ni1jNmFhLTQzODMtYTUxNS0xNmY2MjIyZjRhOTUiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC81OTg3YzliOC1lZGVmLTQ4NmMtODZkNC0wODY2ZGQ4NDgxZTQvIiwiaWF0IjoxNTU1MzIzNzk4LCJuYmYiOjE1NTUzMjM3OTgsImV4cCI6MTU1NTMyNzY5OCwiYWlvIjoiNDJaZ1lMaWs5clBTN3NPMGJTdFh1UHpaVmNsNUFBQT0iLCJhcHBpZCI6IjY1NzEzYWYxLWVhMGMtNDkxMi1iZTIzLWQwMWZmNWNlYzFmZiIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzU5ODdjOWI4LWVkZWYtNDg2Yy04NmQ0LTA4NjZkZDg0ODFlNC8iLCJ0aWQiOiI1OTg3YzliOC1lZGVmLTQ4NmMtODZkNC0wODY2ZGQ4NDgxZTQiLCJ1dGkiOiJXRDk3WGZtcmVrS0kzWVZMMDBKUEFBIiwidmVyIjoiMS4wIn0.Km_v8R3BwT994c_s7Y_lcnHJxPLnVGfk0LWGDxQ7c4EXPnIRUz84RpP2RguSRy3mQqt-VNj_GA0LVWkrrUypbltnoHN7RXuoz6AfU0l9fEYR5gaPZQHcj7eOp9GdHmaJEO-2j-ZAK9rcQs9emh7pbHsz_Z-iBvKlAiBC0Jtiy4sqcBTa0h7pZ-NvbR6-tj038xgg_3zIWqS5ixinE0-V9x5z3iShGU-EusHTQo4dR3CEw4eKF0XoVBOpWHdjhI8wRh0Ht6XoKwey5SICgzMDTMPcE7ddE1B_FNs2jBX_XhUmLpx8TvCHxkhJQ0bos4hT6SZZ8I2NjVEFCigmA7itNw"

    attr_accessor :subscription_key

    # Create the API client and connect to the DataSense API, ensuring we have a valid token
    #
    # @param subscription_key [String] DataSense subscription key
    # @raise OneRoster::InvalidSubscriptionKeyError when DataSense subscription key is invalid
    def initialize(subscription_key:)
      # Subscription key is set and rotated at https://apiportal.datasense.com/developer
      self.subscription_key = subscription_key
      raise DataSense::InvalidSubscriptionKeyError.new("The subscription key is required.") if subscription_key.nil?

      # TODO: When DataSense fix our invalid subscription key, remove this and handle the returned data:
      # rubocop: disable Lint/UnreachableCode
      # {
      #   "token_type": "",
      #   "expires_in": "",
      #   "ext_expires_in": "",
      #   "expires_on": "",
      #   "not_before": "",
      #   "resource": "",
      #   "access_token": ""
      # }
      return

      conn = Faraday.new(url: OAUTH_URI)
      response = conn.post do |req|
        req.headers["Ocp-Apim-Subscription-Key"] = subscription_key
      end

      begin
        handle_response(response)
      rescue DataSense::StandardError
        raise DataSense::InvalidSubscriptionKeyError.new("The subscription key #{subscription_key} is invalid.")
      end
      # rubocop: enable Lint/UnreachableCode
    end

    # Performs an authenticated GET request against the DataSense API
    #
    # @param url [String] Full URL to make the get request to
    # @return [Object] the object converted into the expected format
    def get(url)
      conn = Faraday.new(url: "#{BASE_URI}#{url}")
      response = conn.get do |req|
        req.headers["Ocp-Apim-Subscription-Key"] = subscription_key
        req.headers["Authorization"] = "Bearer #{BEARER_TOKEN}"
      end

      handle_response(response)
    end

    # Handles method chaining, so .schools.all is converted to DataSense::School.all
    #
    # @raise DataSense::InterfaceError The class or method requested is not defined
    def method_missing(method, *_args)
      class_name = class_name_from_method(method)
      if DataSense.const_defined?(class_name)
        klass = Module.const_get("DataSense::#{class_name}")
        instance = klass.new(api: self)
        instance
      else
        super
      end
    end

    # Override respond_to based on method_missing
    def respond_to_missing?(method, include_private = false)
      class_name = class_name_from_method(method)
      DataSense.const_defined?(class_name) || super
    end

    private

    # Convert the given method name into a correctly formatted class name
    #
    # @param method [String] Method name
    # @return [String] Correctly formatted class name
    def class_name_from_method(method)
      method.to_s.singularize.titleize.sub(" ", "")
    end

    # Handle the response from the API
    #
    # @param response [Faraday::Response] Faraday response object
    # @return [Hash] JSON hash of parsed response
    # @raise DataSense::ApiError for error responses from the API
    # @raise DataSense::ConnectionError if unable to connect to the API
    # @raise DataSense::ParserError if unable to parse the response from the API
    def handle_response(response)
      if response
        begin
          status_code = response.status.to_i
          body = response.body
          if status_code == 401
            # Raise AuthorizationError if we're not authorized to access the API
            raise DataSense::AuthorizationError.new(body)
          elsif status_code == 404
            # Raise NotFoundError if the requested resource could not be found
            raise DataSense::NotFoundError.new(body)
          elsif status_code.to_i > 200
            # Raise ApiError for unexpected status codes
            raise DataSense::ApiError.new(body)
          else
            JSON.parse(response.body)
          end
        rescue JSON::ParserError
          # Raise ParserError if we fail to parse the returned JSON
          raise DataSense::ParserError.new(statusCode: response.status, message: "JSON response could not be parsed: #{response.body}")
        end
      else
        # Raise ConnectionError if we're unable to connect to the API
        raise DataSense::ConnectionError.new(statusCode: "0", message: "An error occurred connecting to the API.")
      end
    end
  end
end
