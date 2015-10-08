module Qiniu
  module Storage
    class ObjectManager
      def initialize(auth, config, bucket)
        @auth = auth
        @bucket = bucket
      end

      def list
      end

      def stat(key)
        rs_do '/stat/' + entry(@bucket, key)
      end

      def rename(old_name, new_name)
        move(old_name, @bucket, new_name)
      end

      def copy(old_name, new_name, another_bucket=nil)
        another_bucket = @bucket if another_bucket == nil
        from = entry(@bucket, old_name)
        to = entry(another_bucket, new_name)
        rs_do "/copy/#{from}/#{to}"
      end

      def move(src_key, target_bucket, target_key)
        from = entry(@bucket, src_key)
        to = entry(target_bucket, target_key)
        rs_do "/move/#{from}/#{to}"
      end

      def delete(key)
        rs_do '/stat/' + entry(@bucket, key)
      end

      def change_mime(key, mime)
        obj = entry(@bucket, key)
        encode_mime = Utils.urlsafe_base64_encode(mime)
        rs_do "/chgm/#{obj}/#{encode_mime}"
      end

      def batch(bat)
        rs_do '/batch', bat.to_body
      end

      def rs_do(path, body = nil)
        url = config[:rs_host] + path
        headers = {}
        headers[:content_type] = Http::FORM_MIME if body != nil
        Http.post(url, body, headers, @auth)
      end

      def fetch(url, key=nil)
        resource = Utils.urlsafe_base64_encode(url)
        t = key == nil ? '' : "/to/#{entry(@bucket, key)}"
        io_do "/fetch/#{t}"
      end

      def prefetch(key)
        resource = entry(@bucket, key)
        io_do "/prefetch/#{resource}"
      end

      def io_do(path)
        url = config[:io_host] + path
        Http.post(url, nil, {}, @auth)
      end

      class << self
        def entry(bucket, key)
          if key == nil || bucket == nil
            raise "invalid arg bucket:#{bucket} key:#{key}"
          end
          Utils.urlsafe_base64_encode("#{bucket}:#{key}")
        end
      end
    end

    class Batch
      def initialize
        @ops = []
      end

      def copy(from_bucket, from_key, to_bucket, to_key)
        from = ObjectManager::entry(from_bucket, from_key)
        to = ObjectManager::entry(to_bucket, to_key)
        ops.append("copy/#{from_key}/#{to}")
        self
      end

      def rename(from_bucket, from_key, to_key)
        move(from_bucket, from_key, from_bucket, to_key)
      end

      def move(from_bucket, from_key, to_bucket, to_key)
        from = ObjectManager::entry(from_bucket, from_key)
        to = ObjectManager::entry(to_bucket, to_key)
        ops.append("move/#{from}/#{to}")
        self
      end

      def delete(bucket, keys)
        keys.each do |key|
          res = ObjectManager::entry(bucket, key)
          ops.append("delete/#{res}")
        end
        self
      end

      def stat(bucket, keys)
        keys.each do |key|
          res = ObjectManager::entry(bucket, key)
          ops.append("stat/#{res}")
        end
        self
      end

      def to_body
      end
    end
  end
end
