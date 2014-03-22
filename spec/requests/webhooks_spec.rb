require 'spec_helper'

describe '/deltas' do
  it 'responds with a 200 response code' do
    post '/', delta_json

    expect(response.code).to eq '200'
  end

  it 'syncs to s3' do
    allow_any_instance_of(Fog::Storage::AWS::Files)
      .to receive(:create)

    post '/', delta_json

    expect(Fog::Storage::AWS::Files)
      .to receive(:create)
      .with(
        body: 'test'
      )
  end
end

def delta_json
  { delta: { users: [1, 2]} }.to_json
end
