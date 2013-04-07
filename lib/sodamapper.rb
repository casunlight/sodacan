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
      data.each do |key,val|
        method_name = key.to_sym

        case fields[method_name]
        when "number"
          val = BigDecimal(val)
        when "double"
          val = Float(val)
        when "boolean"
          if val =~ /(true|1)/
            val = true
          else
            val = false
          end
        end

        define_singleton_method(method_name){ val }
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