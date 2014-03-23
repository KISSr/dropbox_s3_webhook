class DeltaJob
  @queue = :default

  def self.perform(dropbox_user_id)
    @@user = User.find_by(dropbox_user_id: dropbox_user_id)

    if @@user.present?

      begin
        delta = dropbox.delta(@@user.cursor)

        process_delta(delta['entries'])

        @@user.cursor = delta['cursor']
      end while delta['has_more']

      @@user.save
    end
  end

  def self.process_delta(delta)
    delta.each do |file_name, metadata|
      if metadata.nil?
        bucket.files.new(key: file_name[1..-1]).destroy
      elsif metadata['is_dir'].present?
        next
      else
        bucket.files.create(
          key: file_name[1..-1],
          body: dropbox.get_file(file_name),
          public: true
        )
      end
    end
  end

  def self.bucket
    aws.directories.new(key: ENV['KISSR_BUCKET'])
  end

  def self.aws
    @@aws ||= Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def self.dropbox
    @@dropbox ||= DropboxClient.new(token)
  end

  def self.token
    @@user.token
  end
end
