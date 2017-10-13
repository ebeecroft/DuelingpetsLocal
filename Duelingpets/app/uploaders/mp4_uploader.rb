class Mp4Uploader < CarrierWave::Uploader::Base

   include CarrierWave::Video
   include CarrierWave::Video::Thumbnailer
   storage :file

   # Override the directory where uploaded files will be stored.
   # This is a sensible default for uploaders that are meant to be mounted:
   def store_dir
      "Resources/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
   end

   def cache_dir
      "Resources/uploads/tmp/"
   end

   version :thumb do
      #process encode_video: [:mp4, resolution: "200x200"]
      #process thumbnail: [{format: 'png', quality: 10, size: 200, strip: true, logger: Rails.logger}]
   end

   def extension_white_list
      %w(mp4)
   end
end
