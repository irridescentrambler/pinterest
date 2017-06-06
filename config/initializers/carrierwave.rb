require 'fog/aws'
CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['ACCESS_KEY_ID'],                        # required
    aws_secret_access_key: ENV['SECRET_ACCESS_KEY'],                        # required
    region:                'ap-south-1',                  # optional, defaults to 'us-east-1'
    #host:                  's3.example.com',             # optional, defaults to nil
    endpoint:              'https://s3.ap-south-1.amazonaws.com', # optional, defaults to nil
    path_style: true
  }
  config.fog_directory  = ENV['BUCKET_NAME']                            # required
  config.fog_public     = true                                        # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}
end