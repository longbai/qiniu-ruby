module Qiniu
  module Storage
    class UploadRecorder
    end
    class ResumeUploader
      def initialize()
      end

      def make_file()

      end

      def make_block()
      end

      def put()
      end

    end
    class FormUploader
      def initialize(data, key, token, params, mime, checkCrc, config)
        @data = data
        @key = key
        @token = token
        @params = params
        @mime = mime
        @checkCrc = checkCrc
        @config = config
      end
      def put()
        body = {:multipart => true, :token=>token, :file => data}
        body[:crc] = Utils.crc32(data) if checkCrc
        body[:key] = key if key != nil
        body[]

        http = Http.new
        http.post(@config[:up_host], body)
      end
    end

    class UploadManager
      class << self
        def filteParam(params)
          params = params || {}
          params.select do |k, v|
            k =~ /^x:/ && v != nil && v != ""
          end
        end
      end
      def initialize(config)
        @config = config || Config.new
      end

      def putFile(local_path, key, token, params=nil, mime=nil, checkCrc=false)
        params = filteParam(params)
        mime = mime || Http.BIN_MIME

        uploader = ResumeUploader.new(data, key, token, params, mime, checkCrc, @config)
        uploader.put
      end

      def putData(data, key, token, params=nil, mime=nil, checkCrc=false)
        params = params || {}
        mime = mime || Http.BIN_MIME
        uploader = FormUploader.new(data, key, token, params, mime, checkCrc, @config)
        uploader.put
      end

    end

  end
end
