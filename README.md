# VHS Video archive

This project was started because I digitized the large collection of family VHS tapes. Each of the resulting video files was 4 hours long and I didn't want to cut them up. Thus with this project you can tag the video every time a new scene comes on and write a small description for it. When a video is marked as done, thumbnail images are created for the marked scnes as well as a thumbnail array for the complete video.

Videos and thumbnails are stored in S3.

## Setup and usage

You will need `imagemagick` and `libav` tools installed on your machine in order to be able to create thumbnails.

### Setup and configuration
After installing in configuring the Rails project in the usual matter, you will need to add the following keys to `config/secrets.yml`:

- `amazon_access_key_id` with your Amazon access key id
- `amazon_secret_access_key` with the corresponding secret
- `amazon_bucket_name` the S3 bucket name where your videos and thumbnails are stored
- `app_username` pick and add the username for the HTTP auth style access to the whole app
- `app_password` pick and add the corresponding password

### Import your first videos
Put your video files into the directory specified in `config/application.rb` under the `config.fetch_directory` directory (defaults to `tmp/videos_to_fetch`)

Now you can import your videos using `rake videos:fetch`

### Tagging your videos
Now go to your application in the browser and click on 'Bearbeiten'. Start the video and mark the every new section by hitting 'Neuer Abschnitt'. Don't forget to save each video marker.

### Initiating thumbnail generation
Once you are done with a single video, go ahead and edit it's meta information. When you mark the checkbox 'Movie ready', the thumbnail generation will begin. Be aware that you video file will be downloaded from S3 to your server and taken apart there. Don't worry, when the job is done it will also delete all of the created thumbnails.
