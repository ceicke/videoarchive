class Chapter < ActiveRecord::Base
  belongs_to :movie

  def generate_thumbnail(movie_file)
    system("avconv -ss #{offset} -r 25 -t 1 -i #{movie_file} -frames 1 #{Rails.root.join('tmp').to_s + '/' + thumbnail_filename}")
  end

  def upload_thumbnail
    aws_object.upload_file(Rails.root.join('tmp').to_s + '/' + thumbnail_filename, acl: 'public-read', content_type: 'image/jpg')
  end

  def delete_thumbnail
    system("rm #{Rails.root.join('tmp').to_s + '/' + thumbnail_filename}")
  end

  def public_url
    aws_object.public_url
  end

  def thumbnail_filename
    "chapter-#{id}.jpg"
  end

  private

  def aws_object
    s3 = s3_object
    s3.bucket(Rails.application.secrets.amazon_bucket_name).object(thumbnail_filename)
  end

  def s3_object
    credentials = Aws::Credentials.new(Rails.application.secrets.amazon_access_key_id, Rails.application.secrets.amazon_secret_access_key)
    Aws::S3::Resource.new(region: 'eu-central-1', credentials: credentials)
  end

end
