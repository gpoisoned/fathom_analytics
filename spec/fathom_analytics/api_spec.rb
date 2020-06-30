require 'spec_helper'

RSpec.describe FathomAnalytics::Api do
  let(:url) { ENV['TEST_URL'] }
  let(:email) { ENV['TEST_EMAIL'] }
  let(:password) { ENV['TEST_PASSWORD'] }

  let(:site_id) { 1 }
  let(:invalid_site_id) { 11111111111111111111111 }
  let(:from) { 1577862000 }
  let(:to) { 1609484399 }

  context "Given an instance of FathomAnalytics::Api" do
    before do
      @client = FathomAnalytics::Api.new(url: url, email: email, password: password)
    end

    describe "#initialize" do
      it "has a url" do
        expect(@client.url).to eq(url)
      end

      it "has an email" do
        expect(@client.email).to eq(email)
      end

      it "has a password" do
        expect(@client.password).to eq(password)
      end
    end

    describe "#sites" do
      before do
        VCR.use_cassette('api/session') do
          @session_response = @client.authenticate
        end
        VCR.use_cassette('api/sites') do
          @sites_response = @client.sites
        end
      end

      it "returns a response" do
        expect(@sites_response).to_not be_nil
      end

      it "returns an array of sites" do
        expect(@sites_response).to be_an_instance_of(Array)
      end

      it "returns site details" do
        expect(@sites_response.first).to have_key("id")
        expect(@sites_response.first).to have_key("name")
        expect(@sites_response.first).to have_key("trackingId")
      end
    end

    describe '#site_stats' do
      context 'When data is present for the site' do
        before do
          VCR.use_cassette("/api/sites/#{site_id}/stats/site") do
            @site_response = @client.site_stats(id: site_id, from: from, to: to)
          end
        end

        it "returns a response" do
          expect(@site_response).to_not be_nil
        end

        it "returns an array of sites" do
          expect(@site_response).to be_an_instance_of(Array)
        end

        it "returns site details" do
          expect(@site_response.first).to have_key("Visitors")
          expect(@site_response.first).to have_key("Pageviews")
          expect(@site_response.first).to have_key("Sessions")
          expect(@site_response.first).to have_key("BounceRate")
          expect(@site_response.first).to have_key("AvgDuration")
          expect(@site_response.first).to have_key("Date")
        end
      end

      context 'When data is not present for the site' do
        before do
          VCR.use_cassette("/api/sites/#{invalid_site_id}/stats/site") do
            @site_response = @client.site_stats(id: invalid_site_id, from: from, to: to)
          end
        end

        it "returns a response" do
          expect(@site_response).to_not be_nil
        end

        it "returns an empty array" do
          expect(@site_response).to be_empty
        end
      end
    end
  end
end
