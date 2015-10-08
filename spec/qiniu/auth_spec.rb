require 'spec_helper'
require 'qiniu'
require 'time'

describe Qiniu::Auth do
  context 'dummy auth' do
    now = Time.parse('Fri Feb 13 23:31:30 UTC 2009')
    dummy = Qiniu::Auth.new('abcdefghklmnopq', '1234567890')
    describe '.sign' do
      it 'data test' do
        s = dummy.sign('test')
        expect(s).to eq('abcdefghklmnopq:mSNBTR7uS2crJsyFr2Amwv1LaYg=')
      end
    end

    describe '.sign_and_take_data' do
      it 'data test' do
        s = dummy.sign_and_take_data('test')
        expect(s).to eq('abcdefghklmnopq:-jP8eEV9v48MkYiBGs81aDxl60E=:dGVzdA==')
      end
    end

    describe '.sign_request' do
      it 'not form request' do
        token = dummy.sign_request('http://www.qiniu.com?go=1', 'test')
        expect(token).to eq('QBox abcdefghklmnopq:cFyRVoWrE3IugPIMP5YJFTO-O-Y=')
      end

      it 'form request' do
        token = dummy.sign_request('http://www.qiniu.com?go=1', 'test', Qiniu::Http::FORM_MIME)
        expect(token).to eq('QBox abcdefghklmnopq:svWRNcacOE-YMsc70nuIYdaa1e4=')
      end
    end

    describe '.is_valid_callback?' do
      it 'form request' do
        check = dummy.is_valid_callback?('QBox abcdefghklmnopq:svWRNcacOE-YMsc70nuIYdaa1e4=',
                                         'http://www.qiniu.com?go=1',
                                         'test',
                                         Qiniu::Http::FORM_MIME)
        expect(check).to eq(true)
      end
    end

    describe '.deadline' do
      it 'within 3600s' do
        t0 = Time.now.to_i + 3600
        t = dummy.class.__send__(:deadline, 3600)
        expect(t <= t0+1 && t>= t0).to eq(true)
      end
    end

    describe '.private_download_url' do
      it 'http' do
        allow(Time).to receive(:now) { now }
        url = dummy.private_download_url('http://www.qiniu.com?go=1')
        expect(url).to eq('http://www.qiniu.com?go=1&e=1234571490&token=abcdefghklmnopq:8vzBeLZ9W3E4kbBLFLW0Xe0u7v4=')
      end

      it 'https' do
        allow(Time).to receive(:now) { now }
        url = dummy.private_download_url('https://www.qiniu.com?go=你好')
        expect(url).to eq('https://www.qiniu.com?go=你好&e=1234571490&token=abcdefghklmnopq:zVxNETeuM7DZj7KMEd-7jShT-zI=')
      end
    end

    describe '.upload_token' do
      it 'enduser' do
        allow(Time).to receive(:now) { now }
        token = dummy.upload_token('1', '2', 3600, {:endUser => 'y'})
        exp = 'abcdefghklmnopq:zx3NdMGffQ0JhUlgGSU5oeTx9Nk=:eyJzY29wZSI6IjE6MiIsImRlYWRsaW5lIjoxMjM0NTcxNDkwLCJlbmRVc2VyIjoieSJ9'
        expect(token).to eq(exp)
      end

      it 'invalid policy' do
        allow(Time).to receive(:now) { now }
        token = dummy.upload_token('1', '2', 3600, {:endUser => 'y', :abc => 'a', 'deadline' => 16})
        exp = 'abcdefghklmnopq:zx3NdMGffQ0JhUlgGSU5oeTx9Nk=:eyJzY29wZSI6IjE6MiIsImRlYWRsaW5lIjoxMjM0NTcxNDkwLCJlbmRVc2VyIjoieSJ9'
        expect(token).to eq(exp)
      end

    end
  end
end
