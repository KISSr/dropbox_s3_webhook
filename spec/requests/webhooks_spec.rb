require 'spec_helper'

describe '/deltas' do
  it 'responds with a 200 response code' do
    allow(Resque).to receive(:enqueue)
    post_json_with_signature(delta.to_json)

    expect(response.code).to eq '200'
  end

  it 'syncs to s3' do
    Resque.stub(:enqueue)

    post_json_with_signature(delta.to_json)

    expect(Resque).to have_received(:enqueue)
  end

  it 'responds with a 400 response code if the signature is wrong' do
    post '/', delta.to_json, {'X-Dropbox-Signature' => 'wrong_signature'}

    expect(response.code).to eq '401'
  end

end

def post_json_with_signature(post_data)
  post '/', post_data,
    {
      'X-Dropbox-Signature' => sign(post_data),
      'CONTENT_TYPE' => 'application/json'
    }
end

def sign(data)
  OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), ENV['DROPBOX_SECRET'], data)
end

def delta
  { delta: { users: [create(:user).dropbox_user_id]} }
end
