module FathomAnalytics
  class Connection
    def initialize(base_url:)
      @base_url = base_url
      @_fd_connection = Faraday.new(
        url: @base_url,
        headers: {'Content-Type' => 'application/json'}
      )
    end

    def get(path: '', params: {}, auth_token:)
      get_url = @base_url + path
      @_fd_connection.get(get_url) do |req|
        params.each do |k, v|
          req.params[k] = v
        end
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = "auth=#{auth_token}" if auth_token
      end
    end

    def post(path: '', params:, auth_token:)
      post_url = @base_url + path
      @_fd_connection.post(post_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = "auth=#{auth_token}" if auth_token
        req.body = params.to_json
      end
    end

    def delete(path: '', auth_token:)
      delete_url = @base_url + path
      @_fd_connection.delete(delete_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = "auth=#{auth_token}" if auth_token
      end
    end
  end
end
