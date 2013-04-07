require 'bigdecimal'
require 'json'
require 'rest-client'
require 'pry'

module SodaMapper
  class Base

    @@url = nil

    # CLASS Methods
    
    def self.all
      self.send_query @@url
    end

    def self.connect (url)
      @@url = url.to_s
    end

    def self.execute (soql)
      query = "#{ @@url }?$query=#{ soql }"
      self.send_query query
    end

    def self.find (id)
      self.where(id: id).first
    end

    def self.search (term)
      query = "#{ @@url }?$q=#{ term }"
      self.send_query query
    end

    def self.where (params)
      query = "#{ @@url }?"

      if params.has_key?(:id)
        query << "$limit=1&$offset=#{ params[:id].to_i-1 }" 
        params.delete(:id)
      end

      unless params.empty?
        query << "$where="

        query = params.to_a.reduce(query) do |q,pair|
          q << "#{ pair[0] }=\"#{ pair[1] }\"&"
        end
        query = query[0..-2]
      end

      self.send_query query
    end


    # INSTANCE METHODS
    def initialize (data, fields)
      @data = data.reduce({}) do |memo,pair|
        key = pair[0].to_sym
        val = nil

        case fields[key]
        when "number"
          val = BigDecimal(pair[1])
        when "double"
          val = Float(pair[1])
        when "boolean"
          if pair[1] =~ /(true|1)/
            val = true
          else
            val = false
          end
        else 
          val = pair[1]
        end

        memo[key] = val
        memo
      end
    end
    
    def method_missing (method, *args)
      if @data.has_key?(method)
        define_method(method){ @data[method] }
        @data[method]
      end
    end

    protected

    def self.send_query (query)
      response = RestClient.get query

      field_names = JSON.parse(response.headers[:x_soda2_fields])
      field_types = JSON.parse(response.headers[:x_soda2_types])
      fields = field_names.zip(field_types).reduce({}) do |memo, pair|
        memo[pair[0].to_sym] = pair[1]
        memo
      end

      JSON.parse(response.body).map{ |data_hash| self.new(data_hash,fields) }
    end
  end
end
