require 'spec_helper'

describe 'verifications' do
  it 'responds with the challenge' do
    get '/', { challenge: 123 }

    expect(response.code).to eq '200'
    expect(response.body).to eq '123'
  end

end
