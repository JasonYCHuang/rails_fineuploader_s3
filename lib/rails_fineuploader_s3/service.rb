require "s3_manager/app"
module S3Manager
  class Service < App
    def rename(tmp_url, unique_url)
      client.copy_object(bucket: bucket, copy_source: copy_source(tmp_url), key: unique_url)
    end

    private

    def copy_source(url)
      bucket + "/" + url
    end
  end
end
