require 'spec_helper'
require 'qiniu'
require 'time'

describe Qiniu::Storage::BucketManager do
  it '.buckets' do
    auth = Qiniu::Auth.new(normal_auth()[0], normal_auth()[1])
    manager = Qiniu::Storage::BucketManager.new(auth)
    list = manager.buckets
    expect(list.include?('rubysdk')).to eq(true)
  end
end
