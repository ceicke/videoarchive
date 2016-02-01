class Movie < ActiveRecord::Base

  validates :filename, presence: true

  def filesize
    aws_object.content_length
  end

  def public_url
    aws_object.public_url
  end

  def content_type
    aws_object.content_type
  end

  private

  def aws_object
    credentials = Aws::Credentials.new(Rails.application.secrets.amazon_access_key_id, Rails.application.secrets.amazon_secret_access_key)
    s3 = Aws::S3::Resource.new(region: 'eu-central-1', credentials: credentials)
    s3.bucket(Rails.application.secrets.amazone_bucket_name).object(filename)
  end

end
