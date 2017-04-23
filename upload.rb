require "aws-sdk"

require "dotenv"
Dotenv.load

BUCKET_NAME = "iain.nl"

client = Aws::S3::Client.new

content_type = ->(key) {
  case key
  when /\.html$/  then "text/html"
  when /\.jpe?g$/ then "image/jpeg"
  when /\.png$/   then "image/png"
  when /\.ico$/   then "image/ico"
  when "feed"     then "application/rss+xml"
  else "text/html"
  end
}

Dir["out/*"].each do |filename|
  next if filename.end_with?(".gz")
  system("gzip -9 #{filename}")
end

Dir["out/*"].each do |filename|
  key = File.basename(filename).sub(/\.gz$/, "")

  File.open(filename, "rb") do |file|
    client.put_object(
      acl:               "public-read",
      key:               key,
      body:              file,
      bucket:            BUCKET_NAME,
      content_type:      content_type[key],
      content_encoding:  "gzip",
      cache_control:     "max-age=3600",
    )
  end

  puts "Uploaded #{key}"
end

client.list_objects_v2(bucket: BUCKET_NAME).contents.each do |object|
  unless File.exist?("out/#{object.key}.gz")
    puts "Deleting #{object.key}"
    client.delete_object(
      bucket: BUCKET_NAME,
      key: object.key,
    )
  end
end

puts "Done"
