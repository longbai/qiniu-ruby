# -*- encoding: utf-8 -*-
# vim: sw=2 ts=2

require 'openssl'
require 'uri'
require 'cgi'
require 'json'

module Qiniu
  class Auth
    class << self
      def deadline(expires_in)
      Time.now.to_i + expires_in
      end
    end
    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
    end

    def sign(data)
      digest=OpenSSL::HMAC.digest('sha1', @secret_key, data)
      return @access_key + ':' + Utils.urlsafe_base64_encode(digest)
    end

    def sign_and_take_data(data)
      d = Utils.urlsafe_base64_encode(data)
      return sign(d) + ':' + d
    end

    def sign_request(url, body = nil, content_type = nil)
      uri = URI.parse(url)
      signing_str = uri.path

      query_string = uri.query
      if query_string.is_a?(String) && !query_string.empty?
        signing_str += '?' + query_string
      end

      signing_str += "\n"

      if body.is_a?(String) && !body.empty? && content_type == Http::FORM_MIME
          signing_str += body
      end

      return 'QBox ' + sign(signing_str)
    end

    def is_valid_callback?(origin_authorization, url, body, content_type)
      authorization = sign_request(url, body, content_type);
      return authorization == origin_authorization
    end

    def private_download_url(url, expires_in=3600)
      d = Auth.deadline(expires_in)
      download_url = url.index('?').is_a?(Fixnum) ? "#{url}&e=#{d}" : "#{url}?e=#{d}"
      sign = sign(download_url)
      return "#{download_url}&token=#{sign}"
    end

    class PutPolicy
      FIELDS = {
        :insertOnly => true,
        :saveKey => true,
        :endUser => true,

        :returnUrl => true,
        :returnBody => true,

        :callbackUrl => true,
        :callbackHost => true,
        :callbackBody => true,
        :callbackBodyType => true,
        :callbackFetchKey => true,

        :persistentOps => true,
        :persistentNotifyUrl => true,
        :persistentPipeline => true,

        :fsizeLimit => true,
        :detectMime => true,
        :mimeLimit => true
      }

      def initialize(scope, deadline, options={})
        @policy = {:scope => scope, :deadline => deadline}
        options.each do |k, v|
          if FIELDS[k.intern]
            @policy[k] = v
          end
        end
      end

      def to_json
        JSON.fast_generate(@policy)
      end
    end

    def upload_token(bucket, key=nil, expires_in=3600, options={})
      deadline = Auth.deadline(expires_in)
      scope = key == nil ? bucket : "#{bucket}:#{key}"
      data = PutPolicy.new(scope, deadline, options).to_json
      sign_and_take_data(data)
    end

  end # class Auth
end # module Qiniu
