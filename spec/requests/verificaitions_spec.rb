require 'spec_helper'

describe 'verifications' do
  it 'responds with the challenge' do
    get '/', { challenge: 123 }, signed_header('dbx')

    expect(response.code).to eq '200'
    expect(response.body).to eq '123'
  end

  it 'responds with a 400 response code if the signature is wrong' do
    get '/', { challenge: 123 }, signed_header('wrong_signature')

    expect(response.code).to eq '400'
  end

  def signed_header(data)
    {'X-Dropbox-Signature' => sign(data)}
  end

  def sign(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), ENV['DROPBOX_SECRET'], data)
  end
end
