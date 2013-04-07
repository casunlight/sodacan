require 'spec_helper'

describe SodaCan::Base do
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
