module RakeUi
  module S3Client
    class << self

      def s3_client
        @s3_client ||= Aws::S3::Client.new(
          region: GlobalConstant.repository.s3.region,
          access_key_id: GlobalConstant.repository.s3.access_key_id,
          secret_access_key: GlobalConstant.repository.s3.secret_access_key)
      end

      def put_object_on_s3(bucket:, key:, body:)
        s3_client.put_object(bucket: bucket, key: key, body: body)
      end
    end

  end
end
