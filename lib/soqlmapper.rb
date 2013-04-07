require 'json'
require 'rest-client'

module SOQLMapper
  class Base
    @@url = nil

    def self.connect (url)
      @@url = url.to_s
    end

    def self.find (id)
      self.where(id: id).first
    end

    def self.execute (soql)
      @query = "#{@@url}?$query=#{soql}"
      self.send_query @query
    end

    def self.where (params)
      @query = "#{@@url}?"

      if params[:id]
        @query << "$limit=1&$offset=#{ params[:id].to_i-1 }" if params[:id].present?
        params.delete(:id)
      end

      unless params.empty?
        @query << "$where="

        @query = params.to_a.reduce(@query) do |q,pair|
          q << "#{ pair[0] }=\"#{ pair[1] }\"&"
        end
        @query = @query[0..-2]
      end

      self.send_query @query
    end

    def self.all
      self.send @@url
    end


    protected

    def self.send_query (query)
      response = RestClient.get query
      JSON.parse(response.body)
    end
  end
end
