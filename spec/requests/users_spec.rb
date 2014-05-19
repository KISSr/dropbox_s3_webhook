require 'spec_helper'

describe '/users' do
  it 'creates users' do
    post '/users', user: {dropbox_user_id: '123', directories: ['test']}

    expect(User.last.dropbox_user_id).to eq '123'
    expect(User.last.directories).to eq ['test']
  end
end
