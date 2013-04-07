module SodaCan
  class Base

    def initialize (data, fields)
      
      used_fields = {}
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
        when "location"
          val = Location.new val
        when "calendar_date"
          val = Time.new val
        end

        used_fields[method_name] = fields[method_name]
        define_singleton_method(method_name){ val }
      end

      define_singleton_method(:_fields){ used_fields }
    end


    class << self

      @@url = nil

      def all
        send_query @@url
      end

      def connect (url)
        @@url = url.to_s
      end

      def execute (soql)
        query = "#{ @@url }?$query=#{ soql }"
        send_query query
      end

      def find (id)
        where(id: id).first
      end

      def search (term)
        query = "#{ @@url }?$q=#{ term }"
        send_query query
      end

      def where (params)
        query = "#{ @@url }?"

        if params.has_key?(:id)
          query << "$limit=1&$offset=#{ params[:id].to_i-1 }"
          params.delete(:id)
        end

        unless params.empty?
          query << "$where="

          query = params.to_a.reduce(query) do |q,pair|
            if pair[1].is_a? Numeric
              q << "#{ pair[0] }=#{ pair[1] }&"
            else
              q << "#{ pair[0] }=\"#{ pair[1] }\"&"
            end
          end
          query = query[0..-2]
        end

        send_query query
      end


      protected

      def send_query (query)
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
end
