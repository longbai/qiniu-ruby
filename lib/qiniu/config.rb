require 'ostruct'

module Qiniu
  class Config
    BLOCK_SIZE = 4 *1024*1024
    def initialize(&block)
      @struct = OpenStruct.new
      @struct.retry_times = 3,
      @struct.rs_host = 'http://rs.qiniu.com'
      @struct.api_host = 'http://api.qiniu.com'
      @struct.rsf_host = 'http://rsf.qbox.me'
      @struct.io_host = 'http://iovip.qbox.me'
      @struct.zone = ZONE_HUADONG_1
       # 如果文件大小大于此值则使用断点上传, 否则使用Form上传
      @struct.put_threshold = BLOCK_SIZE
      @struct.connect_timeout = 10
      @struct.response_timeout = 30
      @struct.logger = nil

      @struct.instance_eval &block if block_given?

      @struct.up_host = @struct.zone.up_host
      @struct.up_host_backup = @struct.zone.up_host_backup
    end

    def [] (key)
      @struct.__send__(key)
    end

  end

  class Zone
    def initialize(up_host, up_host_backup)
      @up_host = up_host
      @up_host_backup = up_host_backup
    end

    def up_host
      @up_host
    end

    def method_missing
      puts 'aaaa'
    end

    def up_host_backup
      @up_host_backup
    end
  end

  ZONE_HUADONG_1 = Zone.new('http://up.qiniu.zom', 'http://upload.qiniu.com')
  ZONE_HUABEI_1 = Zone.new('http://up-z1.qiniu.zom', 'http://upload-z1.qiniu.com')
end
