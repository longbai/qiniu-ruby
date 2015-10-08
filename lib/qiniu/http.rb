require 'restclient'
module Qiniu
  class Http
    FORM_MIME = 'application/x-www-form-urlencoded'
    JSON_MIME = 'application/json'
    BIN_MIME = 'application/octet-stream'

    USER_AGENT = 'QiniuRuby/' + VERSION + ' ('+RUBY_PLATFORM+')' + ' Ruby/'+ RUBY_VERSION,

    def initialize(auth=nil, logger=nil, timeout=30, open_timeout=10)
      @auth = auth
      @logger = logger
      @timeout = timeout
      @open_timeout = open_timeout
    end

    def post(url, payload, headers={})
      headers[:user_agent] = USER_AGENT
      headers[:Authorization] = @auth.sign_request(url, payload, headers[:content_type]) if @auth != nil
      opts={:timeout => @timeout, :open_timeout => @open_timeout,
        :method => :post, :url => url, :payload => payload, :headers => headers}

      RestClient::Request.new(opts).execute do
        #log
      end
    end

    def get(url, headers={})
      headers[:user_agent] = USER_AGENT
      headers[:Authorization] = @auth.sign_request(url) if @auth != nil


      opts={:timeout => @timeout, :open_timeout => @open_timeout,
        :method => :get, :url => url, :headers => headers}

      x = RestClient::Request.new(opts).execute do |response|
        code = response.code
        reqId = response.headers[:x_reqid]

        case response.code

        when 200
          if @logger != nil
            @logger.debug(response.code, response)
          end
          response
        when 401
          raise SomeCustomExceptionIfYouWant
        else
          response.return!(request, result, &block)
        end
      end
      ctype = x.headers[:content_type]
      if ctype.include? JSON_MIME
        return Utils.safe_json_parse(x.body)
      else
        return x.body
      end
    end
    private
    def log200(response)
    end

    def via(headers)
      if headers[:x_via] != nil
        return headers[:x_via]
      end

      if headers[:x_px] != nil
        return headers[:x_px]
      end

      if headers[:fw_via] != nil
        return headers[:fw_via]
      end
    end
  end
end
