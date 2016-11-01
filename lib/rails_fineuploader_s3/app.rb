require "aws"

module S3Manager
  class App
    attr_reader :bucket, :region, :access_key, :secret_key
    def initialize(args = {})
      @bucket = args.fetch(:bucket, ENV["S3_BUCKET"])
      @region = args.fetch(:region, ENV["S3_REGION"])
      @access_key = args.fetch(:access_key, ENV["S3_ACCESS_KEY"])
      @secret_key = args.fetch(:secret_key, ENV["S3_SECRET_KEY"])
    end

    def client
      @client ||= Aws::S3::Client.new(region: region, credentials: credentials)
    end

    private

    def credentials
      @credentials ||= Aws::Credentials.new(access_key, secret_key)
    end
  end
end
