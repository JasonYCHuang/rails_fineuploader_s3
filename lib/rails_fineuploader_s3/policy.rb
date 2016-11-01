require "base64"
require "openssl"
require "digest/sha1"
require "cgi"
require "s3_manager/app"

module S3Manager
  class Policy < App
    attr_reader :params, :type, :content_length, :user_email, :conditions
    def initialize(args = {})
      super(args)
      @params = args.fetch(:params)
      @type = args.fetch(:type, %w(jpeg jpg gif png bmp))
      @content_length = args.fetch(:content_length, 1024 * 1024)
      @user_email = args.fetch(:user_email)
      @conditions = conditions_hash
    end

    def generate
      valid_policy ? { "policy" => policy, "signature" => signature } : false
    end

    private

    def policy
      @policy ||= Base64.encode64(policy_document).delete("\n")
    end

    def policy_document
      @policy_document ||= params.extract!("expiration", "conditions").to_json
    end

    def signature
      @signature ||= Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new("sha1"), secret_key, policy
        )
      ).delete("\n")
    end

    def valid_policy
      conditions.present? && valid_bucket && valid_type && valid_content_length && valid_email
    end

    def valid_bucket
      bucket == conditions["bucket"]
    end

    def valid_type
      type.include?(file_type)
    end

    def valid_email
      user_email == CGI.unescape(conditions["x-amz-meta-email"])
    end

    def file_type
      conditions["Content-Type"].gsub("image/", "")
    end

    def valid_content_length
      clr = conditions["content-length-range"]
      clr[:min].to_i <= content_length && clr[:max].to_i <= content_length
    end

    # convert params["conditions"] from hash+array to pure hash
    def conditions_hash
      params["conditions"].grep(HashWithIndifferentAccess).reduce(:merge).merge(clr_hash)
    rescue
      Rails.logger.error("**** S3 policy generation error, invalid params ***")
      return nil
    end

    # convert ["content-length-range", "0", "1048576"]
    #      to {"content-length-range"=>{:min=>"0", :max=>"1048576"}}
    def clr_hash
      params["conditions"].grep(Array).each do |a|
        if a[0] == "content-length-range"
          return { "content-length-range" => { min: a[1], max: a[2] } }
        end
      end
    end
  end
end
