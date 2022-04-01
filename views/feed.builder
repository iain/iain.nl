# frozen_string_literal: true

xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "iain.nl"
    xml.description "Article feed of iain.nl"
    xml.link "http://www.iain.nl"
    xml.pubDate CGI.rfc1123_date(posts.first.publish.to_time)
    posts.each do |post|
      xml.item do
        xml.title   post.title
        xml.link    "http://www.iain.nl/#{post.path}"
        xml.pubDate CGI.rfc1123_date(post.publish.to_time)
        xml.description do
          xml.cdata! post.body
        end
        xml.guid    "http://www.iain.nl/#{post.path}"
        xml.author  "iain@iain.nl (iain hecker)"
      end
    end
  end
end
