require 'spec_helper'

describe Qiniu::Utils do

  describe '.etag' do
    def check(size, hash)
        temp_file(size) do |f|
        expect(Qiniu::Utils.etag(f.path)).to eq(hash)
      end
    end

    it 'empty' do
      check(0, 'lto5o-5ea0sNMlW_75VgGJCv2AcJ')
    end

    it '1KB' do
      check(1, 'Fiick_GFDkRgtboxNvXESMCP7EWn')
    end

    it '4MB' do
      check(4*1024, 'lg0gQzOM40bVfR8TCsRokhxUcSjZ')
    end

    it '4MB1KB' do
      check(4*1024+1, 'lplnl_2XELhzqfWovUUCLQiHRwgj')
    end

    it '8MB' do
      check(8*1024, 'lv2iG4LlZ16LApwOvhiJYPgnalZm')
    end

    it '8MB1KB' do
      check(8*1024+1, 'lrrpBQzfqcDIcriYZ6WylCTkTcoW')
    end
  end

  describe '.crc32' do
    it 'empty' do
      expect(Qiniu::Utils.crc32('')).to eq(0)
    end

    it 'abc value' do
      expect(Qiniu::Utils.crc32('abc')).to eq(891568578)
    end
  end

  describe '.safe_json_parse' do
    it 'return a hash' do
      expect(Qiniu::Utils.safe_json_parse('{"foo": "bar"}')).to eq({"foo" => "bar"})
    end

    it 'return a empty hash' do
      expect(Qiniu::Utils.safe_json_parse('{}')).to eq({})
    end

    it 'return a empty hash, does not throw error' do
      expect(Qiniu::Utils.safe_json_parse('')).to eq({})
    end

    it 'return a empty hash, does not throw error' do
      expect(Qiniu::Utils.safe_json_parse('abc:def')).to eq({})
    end
  end

  describe '.urlsafe_base64_encode' do
    it 'return encode' do
      expect(Qiniu::Utils.urlsafe_base64_encode('abc')).to eq('YWJj')
    end
  end

  describe '.urlsafe_base64_decode' do
    it 'return decode' do
      expect(Qiniu::Utils.urlsafe_base64_decode('YWJj')).to eq('abc')
    end
  end
end
