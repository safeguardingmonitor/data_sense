# frozen_string_literal: true

module DataSense
  class Base
    # Initializes the data model with an instance of the API
    #
    # @param api [DataSense::API] API to make connections through
    # @return void
    def initialize(api:)
      @api = api
    end

    # Returns all records with no filtering
    #
    # @return [Hash] Hash of data
    def all
      response = @api.get(base_path)
      response[resource.pluralize]
    end

    # Returns the record found with the given UUID
    #
    # @param uuid [String] The UUID for the resource
    # @return [Hash] Hash of data
    # @raise DataSense::NotFoundError If the requested UUID is not found
    def get(uuid:)
      response = @api.get("#{base_path}/#{uuid}")
      response[resource]
    end

    # Search the records with the given filters
    #
    # @param fields [Array] Array of fields to return, e.g. ["id", "type"]. Leave blank to return all fields
    # @param filter [Hash] A key/value pair to filter the response on, e.g. { type: "district" }
    # @param offset [Integer] The number of records to skip in the returned response
    # @param limit [Integer] The number of records to limit the returned response to
    # @param sort [String] Search field and (optionally) direction, e.g. "name" or "name DESC". Defaults to ASC
    # @return [Hash] Hash of data
    def where(fields: [], filter: {}, offset: 0, limit: 0, sort: "")
      url = "#{base_path}?"
      params = []

      if fields.any?
        params << "fields=#{fields.join(",")}"
      end

      if filter.any?
        key = filter.keys.first.to_s
        value = filter.values.first
        params << "filter=#{key}=#{value}"
      end

      params << "limit=#{limit}" unless limit.zero?
      params << "offset=#{offset}" unless offset.zero?
      params << "sort=#{sort}" unless sort.empty?

      url = "#{base_path}?#{params.join("&")}" if params

      response = @api.get(url)
      response[resource.pluralize]
    end

    private

    # Return the base path for the model's requests, / followed by pluralized object name
    #
    # @return [String] Base path
    def base_path
      "/" + resource.pluralize
    end

    # Return the normalised resource name based on the class name
    #
    # @return [String] Normalised resource name
    def resource
      self.class.name.demodulize.downcase
    end
  end
end
