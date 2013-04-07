module SodaCan
  class Location
    def initialize (params)
      lat = Float(params['latitude'])
      long = Float(params['longitude'])
      addr = JSON.parse(params['human_address'])
      define_singleton_method(:latitude){ lat }
      define_singleton_method(:longitude){ long }
      define_singleton_method(:human_address){ addr }
    end
  end
end
