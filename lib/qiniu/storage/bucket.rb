module Qiniu
  module Storage
    class BucketManager
      def initialize(auth, config=nil)
        @config = config || Config.new
        @http = Http.new(auth, @config[:logger])
      end

      def buckets
        url = @config[:rs_host] + '/buckets'
        @http.get(url)
      end
    end
  end

end
