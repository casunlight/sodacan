require 'spec_helper'
require 'pry'

describe SOQLMapper::Base do
  before do
  end

  describe ".connect" do
    it "sets the url" do
      @url = "some_url"
      expect {
        puts Market.connect( @url )
      }.to change { Market.instance_variables }.to eq(@url)

    end

  end
end
