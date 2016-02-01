namespace :videos do
  desc "Fetch and import new videos from #{Rails.configuration.fetch_directory}"
  task fetch: :environment do

    credentials = Aws::Credentials.new(Rails.application.secrets.amazon_access_key_id, Rails.application.secrets.amazon_secret_access_key)
    s3 = Aws::S3::Resource.new(region: 'eu-central-1', credentials: credentials)

    Dir[Rails.configuration.fetch_directory + '/*.mp4'].each do |file_name|
      next if File.directory? file_name

      movie_uuid = SecureRandom.uuid

      print "Importing: #{File.basename file_name} -> #{movie_uuid}"

      m = Movie.new
      m.filename = movie_uuid

      obj = s3.bucket(Rails.application.secrets.amazone_bucket_name).object(movie_uuid)
      obj.upload_file(file_name, acl: 'public-read', content_type: 'video/mp4')

      m.save

      print " [done]\n"
    end
  end

end
