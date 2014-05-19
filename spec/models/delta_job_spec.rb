require 'spec_helper'

describe DeltaJob, '#work' do
  it 'Creates files that have been added' do
    Fog.mock!

    allow_any_instance_of(Fog::Storage::AWS::Files)
      .to receive(:create)

    Fog::Storage::AWS::Files.any_instance
      .should_receive(:create)
      .with(
        key: 'test/test.txt',
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
              'test/test.txt',
              {
                file_name: 'test/test.txt'
              }
            ]
          ]
        }.stringify_keys
      )

    allow_any_instance_of(DropboxClient)
      .to receive(:get_file)
      .and_return('test')

    user = create(:user, directories: ['test'])

    Resque.enqueue(DeltaJob, user.dropbox_user_id)
  end
end

