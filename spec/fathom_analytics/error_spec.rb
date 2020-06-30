require 'spec_helper'

RSpec.describe FathomAnalytics::Error do
  describe "#inspect" do
    context "when its an internal gem error" do
      it "creates an error with a message" do
        error = FathomAnalytics::Error.new("This is an error")
        expect(error.message).to eq("This is an error")
      end
    end
  end
end
