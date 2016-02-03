require 'net/http'

class Movie < ActiveRecord::Base

  has_many :chapters, dependent: :destroy

  validates :filename, presence: true

  after_commit :create_thumbnails

  def filesize
    aws_object.content_length
  end

  def public_url
    aws_object.public_url
  end

  def content_type
    aws_object.content_type
  end

  def thumbnail_public_url
    thumbnail_aws_object.public_url
  end

  def generate_chapter_thumbnails
    download_movie
    chapters.each do |c|
      c.generate_thumbnail(temp_filename)
      c.upload_thumbnail
      c.update_attribute(:thumbnail_ready, true)
    end
  end

  def generate_thumbnail
    tiling = "#{Math.sqrt(chapters.count).ceil}x#{Math.sqrt(chapters.count).ceil}"
    filelist = Chapter.all.map { |c| Rails.root.join('tmp').to_s + '/' + c.thumbnail_filename }.join(' ')

    system("montage -mode concatenate -geometry 600x -tile #{tiling} #{filelist} -auto-orient #{Rails.root.join('tmp').to_s + '/' + thumbnail_filename}")

    aws_object.upload_file(Rails.root.join('tmp').to_s + '/' + thumbnail_filename, acl: 'public-read', content_type: 'image/jpg')
    update_attribute(:thumbnail_ready, true)
  end

  def delete_tempfiles
    chapters.each do |c|
      c.delete_thumbnail
    end
    delete_movie
    delete_thumbnail
  end

  private
  def temp_filename
    Rails.root.join('tmp').to_s + '/' + filename
  end

  def thumbnail_filename
    "thumbnail-#{filename}.jpg"
  end

  def aws_object
    s3 = s3_object
    s3.bucket(Rails.application.secrets.amazon_bucket_name).object(filename)
  end

  def thumbnail_aws_object
    s3 = s3_object
    s3.bucket(Rails.application.secrets.amazon_bucket_name).object(thumbnail_filename)
  end

  def s3_object
    credentials = Aws::Credentials.new(Rails.application.secrets.amazon_access_key_id, Rails.application.secrets.amazon_secret_access_key)
    Aws::S3::Resource.new(region: 'eu-central-1', credentials: credentials)
  end

  def download_movie
    unless File.exists?(temp_filename)
      system("wget --quiet #{public_url} -O #{temp_filename}")
    end
  end

  def delete_movie
    system("rm #{temp_filename}")
  end

  def delete_thumbnail
    system("rm #{Rails.root.join('tmp').to_s + '/' + thumbnail_filename}")
  end

  def create_thumbnails
    if self.movie_ready
      CreateThumbnailsJob.perform_later self
    end
  end

end
