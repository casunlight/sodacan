module SodaCan
  class Location
    def initialize (params)
      define_singleton_method(:latitude){ params['latitude'].to_f }
      define_singleton_method(:longitude){ params['longitude'].to_f }
    end
  end
end
