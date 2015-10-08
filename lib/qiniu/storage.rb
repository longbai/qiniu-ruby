module Qiniu
  # ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  # SRC = ROOT + '/lib/qiniu'
  module Storage
    require 'qiniu/storage/upload'
    autoload :BucketManager, "qiniu/storage/bucket"
    autoload :ObjectManager, 'qiniu/storage/object'
  end
end
