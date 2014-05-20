class DeltaJob
  @queue = :default

  def self.perform(dropbox_user_id)
    @@user = User.find_by(dropbox_user_id: dropbox_user_id)

    if @@user.present?
      @@dropbox = DropboxClient.new(token)

      begin
        delta = @@dropbox.delta(@@user.cursor)

        process_entries(delta['entries'])

        @@user.cursor = delta['cursor']
      end while delta['has_more']

      @@user.save
    end
  end

  def self.process_entries(entries)
    entries.each do |file_name, metadata|
      file_name.sub!('/','')

      if included_in_users_directories?(file_name)
        process_file(file_name, metadata)
      end
    end
  end

  def self.included_in_users_directories?(file_name)
    @@user.directories.any?{|directory| file_name.starts_with?(directory)}
  end

  def self.process_file(file_name, metadata)
    if metadata.nil?
      bucket.files.new(key: file_name).destroy
    elsif !metadata['is_dir']
      bucket.files.create(
        key: file_name,
        body: @@dropbox.get_file(file_name),
        public: true
      )
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

  def self.token
    @@user.token
  end
end
