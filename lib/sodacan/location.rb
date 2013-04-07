module SodaCan
  class Location
    def initialize (params)
      lat = Float(params['latitude'])
      long = Float(params['longitude'])
      define_singleton_method(:latitude){ lat }
      define_singleton_method(:longitude){ long }
    end
  end
end
