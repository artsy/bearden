class S3Uploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  def extension_white_list
    %w(csv)
  end

  def store_dir
    'uploads'
  end
end
