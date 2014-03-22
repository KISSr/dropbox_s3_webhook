require 'spec_helper'

describe DeltaJob, '#work' do
  it 'Creates files that have been added' do
    Fog.mock!

    allow_any_instance_of(Fog::Storage::AWS::Files)
      .to receive(:create)

    Fog::Storage::AWS::Files.any_instance
      .should_receive(:create)
      .with(
        key: 'test.txt',
        body: 'test',
        public: true
      )

    allow_any_instance_of(DropboxClient)
      .to receive(:delta)
      .and_return(
        {
          cursor: '123',
          entries: [
            [
              'test.txt',
              {
                file_name: 'test.txt'
              }
            ]
          ]
        }.stringify_keys
      )

    allow_any_instance_of(DropboxClient)
      .to receive(:get_file)
      .and_return('test')

    user = create(:user)
    job = DeltaJob.new

    job.work(user.dropbox_user_id)

  end
end

