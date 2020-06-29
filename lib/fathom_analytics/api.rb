require 'pry'

module FathomAnalytics
  class Api
    LIMIT = 50

    attr_reader :url, :email, :password

    def initialize(url:, email:, password:)
      @url = url
      @email = email
      @password = password
      @auth_token = nil
    end

    def sites
      get_request("/api/sites")
    end

    def site_realtime_stats(id:)
      get_request("/api/sites/#{id}/stats/site/realtime")
    end

    def site_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      get_request("/api/sites/#{id}/stats/site", before, after, limit, offset)
    end

    def site_agg_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      get_request("/api/sites/#{id}/stats/site/agg", before, after, limit, offset)
    end

    def page_agg_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      get_request("/api/sites/#{id}/stats/pages/agg", before, after, limit, offset)
    end

    def page_agg_page_views_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      get_request("/api/sites/#{id}/stats/pages/page_views", before, after, limit, offset)
    end

    def referrer_agg_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      get_request("/api/sites/#{id}/stats/referrers/agg", before, after, limit, offset)
    end

    def referrer_agg_page_views_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      get_request("/api/sites/#{id}/stats/referrers/page_views", before, after, limit, offset)
    end

    def authenticate
      response = connection.post(path: '/api/session', params: {
        "Email": email,
        "Password": password
      })
      set_auth_token(response)
      response
    end

    private

    def get_request(path, before = nil, after = nil, limit = nil, offset = nil)
      ensure_auth_token
      params = {}
      params['before'] = before if before
      params['after'] = after if after
      params['limit'] = limit if limit
      params['offset'] = offset if offset

      response = connection.get(
        path: path,
        auth_token: @auth_token,
        params: params
      )

      binding.pry
      if response.status == 200
        JSON.parse(response.body)
      else
        raise FathomAnalytics::Error.new(response.status)
      end
    end

    def ensure_auth_token
      return unless @auth_token.nil?

      set_auth_token(authenticate)
    end

    def set_auth_token(response)
      set_cookie_header = response.headers['set-cookie']
      @auth_token = parse_auth_header(set_cookie_header) if set_cookie_header
    end

    def parse_auth_header(header)
      matches = header.match(/auth=([a-zA-Z0-9\-_]+);/)
      matches[1] if matches
    end

    def connection
      @connection ||= FathomAnalytics::Connection.new(base_url: url)
    end
  end
end
