# -*- encoding: utf-8 -*-
# vim: sw=2 ts=2

require 'uri'
require 'cgi'
require 'json'
require 'zlib'
require 'base64'
require 'digest'

module Qiniu
  module Utils extend self

    def urlsafe_base64_encode(content)
      Base64.urlsafe_encode64(content)
    end

    def urlsafe_base64_decode(encoded_content)
      Base64.urlsafe_decode64(encoded_content)
    end

    def safe_json_parse(data)
      JSON.parse(data)
    rescue JSON::ParserError
      {}
    end

    def etag(file_name)
      sha1 = []
      open(file_name, "rb") do |f|
        until f.eof?
          chunk = f.read(Config::BLOCK_SIZE)
          sha1 << Digest::SHA1.digest(chunk)
        end
      end

      if sha1.size == 1
        Base64.urlsafe_encode64(0x16.chr + sha1[0])
      else
        Base64.urlsafe_encode64(0x96.chr + Digest::SHA1.digest(sha1.join))
      end
    end

    def crc32(data)
      Zlib.crc32(data)
    end
  end # module Utils
end # module Qiniu
