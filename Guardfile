guard :shell do
  watch(/.*/) do |m|
    if !m[0].start_with?("out/") && !m[0].start_with?(".sass-cache/")
      puts "#{m[0]} changed. Regenerating..."
      system "ruby generate.rb"
    end
  end
end
