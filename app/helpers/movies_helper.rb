module MoviesHelper

  def format_offset_seconds(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
  
end
