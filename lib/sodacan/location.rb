module SodaCan
  class Location
    def initialize (params)
      lat = nil
      lat = Float(params['latitude']) if params['latitude']
      long = nil
      long = Float(params['longitude']) if params['longitude']
      define_singleton_method(:latitude){ lat }
      define_singleton_method(:longitude){ long }
    end
  end
end
