require 'spec_helper'

RSpec.describe FathomAnalytics::Api do
  let(:url) { ENV['TEST_URL'] }
  let(:email) { ENV['TEST_EMAIL'] }
  let(:password) { ENV['TEST_PASSWORD'] }
  let(:invalid_password) { ENV['TEST_INVALID_PASSWORD'] }

  let(:site_id) { 1 }
  let(:invalid_site_id) { 11111111111111111111111 }
  let(:from) { 1577862000 }
  let(:to) { 1609484399 }

  context "Given an instance of FathomAnalytics::Api" do
    context 'With valid credentials' do
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

      describe '#site_agg_stats' do
        context 'When data is present for the site' do
          before do
            VCR.use_cassette("/api/sites/#{site_id}/stats/site/agg") do
              @site_agg_stats_response = @client.site_agg_stats(id: site_id, from: from, to: to)
            end
          end

          it "returns a response" do
            expect(@site_agg_stats_response).to_not be_nil
          end

          it "returns agg site details" do
            expect(@site_agg_stats_response).to have_key("Visitors")
            expect(@site_agg_stats_response).to have_key("Pageviews")
            expect(@site_agg_stats_response).to have_key("Sessions")
            expect(@site_agg_stats_response).to have_key("BounceRate")
            expect(@site_agg_stats_response).to have_key("AvgDuration")
            expect(@site_agg_stats_response).to have_key("Date")
          end
        end
      end

      describe '#page_agg_stats' do
        context 'When data is present for the site' do
          before do
            VCR.use_cassette("/api/sites/#{site_id}/stats/pages/agg") do
              @page_agg_stats_response = @client.site_agg_stats(id: site_id, from: from, to: to)
            end
          end

          it "returns a response" do
            expect(@page_agg_stats_response).to_not be_nil
          end

          it "returns agg site details" do
            expect(@page_agg_stats_response).to have_key("Visitors")
            expect(@page_agg_stats_response).to have_key("Pageviews")
            expect(@page_agg_stats_response).to have_key("Sessions")
            expect(@page_agg_stats_response).to have_key("BounceRate")
            expect(@page_agg_stats_response).to have_key("AvgDuration")
            expect(@page_agg_stats_response).to have_key("Date")
          end
        end
      end

      describe '#page_agg_page_views_stats' do
        context 'When data is present for the site' do
          before do
            VCR.use_cassette("/api/sites/#{site_id}/stats/pages/agg/pageviews") do
              @page_agg_page_views_response = @client.page_agg_page_views_stats(id: site_id, from: from, to: to)
            end
          end

          it "returns a response" do
            expect(@page_agg_page_views_response).to_not be_nil
            expect(@page_agg_page_views_response.is_a?(Numeric)).to be(true)
          end
        end
      end

      describe '#referrer_agg_stats' do
        context 'When data is present for the site' do
          before do
            VCR.use_cassette("/api/sites/#{site_id}/stats/referrers/agg") do
              @referrer_agg_stats_response = @client.referrer_agg_stats(id: site_id, from: from, to: to)
            end
          end

          it "returns a response" do
            expect(@referrer_agg_stats_response).to_not be_nil
          end

          it "returns an array of referrers" do
            expect(@referrer_agg_stats_response).to be_an_instance_of(Array)
          end

          it "returns agg details" do
            expect(@referrer_agg_stats_response.first).to have_key("Hostname")
            expect(@referrer_agg_stats_response.first).to have_key("Pathname")
            expect(@referrer_agg_stats_response.first).to have_key("Group")
            expect(@referrer_agg_stats_response.first).to have_key("Visitors")
            expect(@referrer_agg_stats_response.first).to have_key("Pageviews")
            expect(@referrer_agg_stats_response.first).to have_key("BounceRate")
            expect(@referrer_agg_stats_response.first).to have_key("AvgDuration")
            expect(@referrer_agg_stats_response.first).to have_key("KnownDurations")
            expect(@referrer_agg_stats_response.first).to have_key("Date")
          end
        end
      end

      describe '#referrer_agg_page_views_stats' do
        context 'When data is present for the site' do
          before do
            VCR.use_cassette("/api/sites/#{site_id}/stats/referrers/agg/pageviews") do
              @referrer_agg_page_views_response = @client.referrer_agg_page_views_stats(id: site_id, from: from, to: to)
            end
          end

          it "returns a response" do
            expect(@referrer_agg_page_views_response).to_not be_nil
            expect(@referrer_agg_page_views_response.is_a?(Numeric)).to be(true)
          end
        end
      end
    end

    context 'With invalid credentials' do
      before do
        @client = FathomAnalytics::Api.new(url: url, email: email, password: invalid_password)

      end

      it 'throws an error' do
        expect {
          VCR.use_cassette("/api/invalid_session") do
            @client.authenticate
          end
        }.to raise_error(FathomAnalytics::Error)
      end
    end
  end
end
