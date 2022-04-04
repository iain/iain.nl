# frozen_string_literal: true

module Files

  def self.content_type(filename)
    case filename
    when /\.css$/   then "text/css"
    when /\.jpe?g$/ then "image/jpeg"
    when /\.png$/   then "image/png"
    when /\.ico$/   then "image/ico"
    when /\.woff2$/ then "font/woff2"
    when /\.woff$/  then "font/woff"
    when "feed"     then "application/rss+xml"
    else "text/html"
    end
  end

  def self.max_age(filename)
    case filename
    when /\.woff2?$/ then 31536000
    else 3600
    end
  end

  def self.upload(filename:, client:, bucket:)
    key = filename.delete_prefix("out/").delete_suffix(".gz")
    File.open(filename, "rb") do |file|
      client.put_object(
        acl:               "public-read",
        key:               key,
        body:              file,
        bucket:            bucket,
        content_type:      content_type(key),
        content_encoding:  "gzip",
        cache_control:     "max-age=#{max_age(key)},public",
      )
    end
    puts "Uploaded #{key}"
  end

  def self.delete_stale(client:, bucket:)
    client.list_objects_v2(bucket: bucket).contents.each do |object|
      unless File.exist?("out/#{object.key}.gz")
        puts "Deleting #{object.key}"
        s3.delete_object(bucket: bucket, key: object.key)
      end
    end
  end

end
