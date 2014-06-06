require "aws-sdk"

AWS.config(
  access_key_id: ENV["PERSONAL_AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["PERSONAL_AWS_SECRET_ACCESS_KEY"],
)

objects = AWS::S3.new.buckets["www.iain.nl"].objects

Dir["out/*"].each do |file|
  key = File.basename(file)
  objects[key].write(
    Pathname(file),
    :acl => :public_read
  )
  puts "Uploaded #{key}"
end

objects.each do |obj|
  unless File.exist?("out/#{obj.key}")
    puts "Deleting #{obj.key}"
    obj.delete
  end
end

puts "Done"
