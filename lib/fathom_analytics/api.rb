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

    def add_site(name:)
      post_request(path: "/api/sites", params: { name: name })
    end

    def remove_site(id:)
      delete_request(path: "/api/sites/#{id}")
    end

    def sites
      get_request(path: "/api/sites")
    end

    def site_realtime_stats(id:)
      get_request(path: "/api/sites/#{id}/stats/site/realtime")
    end

    def site_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      path = "/api/sites/#{id}/stats/site"
      get_request(path: path, before: before, after: after, limit: limit, offset: offset)
    end

    def site_agg_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      path = "/api/sites/#{id}/stats/site/agg"
      get_request(path: path, before: before, after: after, limit: limit, offset: offset)
    end

    def page_agg_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      path = "/api/sites/#{id}/stats/pages/agg"
      get_request(path: path, before: before, after: after, limit: limit, offset: offset)
    end

    def page_agg_page_views_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      path = "/api/sites/#{id}/stats/pages/page_views"
      get_request(path: path, before: before, after: after, limit: limit, offset: offset)
    end

    def referrer_agg_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      path = "/api/sites/#{id}/stats/referrers/agg"
      get_request(path: path, before: before, after: after, limit: limit, offset: offset)
    end

    def referrer_agg_page_views_stats(id:, before:, after:, limit: LIMIT, offset: 0)
      path = "/api/sites/#{id}/stats/referrers/page_views"
      get_request(path: path, before: before, after: after, limit: limit, offset: offset)
    end

    def authenticate
      params = {
        "Email": email,
        "Password": password
      }
      response = post_request(path: "/api/session", params: params, authenticated: false) do |raw_response|
        set_auth_token(raw_response)
      end
      response
    end

    private

    def get_request(path:, before: nil, after: nil, limit: nil, offset: nil, authenticated: true)
      ensure_auth_token if authenticated

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

      if response.status == 200
        JSON.parse(response.body)
      else
        raise FathomAnalytics::Error.new(response.status)
      end
    end

    def post_request(path:, params:, authenticated: true, &block)
      ensure_auth_token if authenticated

      response = connection.post(
        path: path,
        params: params,
        auth_token: @auth_token
      )

      if response.status == 200
        yield response if block_given?

        JSON.parse(response.body)
      else
        raise FathomAnalytics::Error.new(response.status)
      end
    end

    def delete_request(path:, authenticated: true)
      ensure_auth_token if authenticated

      response = connection.delete(
        path: path,
        auth_token: @auth_token
      )

      if response.status == 200
        yield response if block_given?

        JSON.parse(response.body)
      else
        raise FathomAnalytics::Error.new(response.status)
      end
    end

    def ensure_auth_token
      return unless @auth_token.nil?

      authenticate
    end

    def set_auth_token(response)
      set_cookie_header = response.headers['set-cookie']
      @auth_token = parse_auth_header(set_cookie_header)

      raise FathomAnalytics::Error.new("Failed to retrieve auth key") unless @auth_token
    end

    def parse_auth_header(header)
      return nil if header.nil?

      matches = header.match(/auth=([a-zA-Z0-9\-_]+);/)
      matches[1] if matches
    end

    def connection
      @connection ||= FathomAnalytics::Connection.new(base_url: url)
    end
  end
end
