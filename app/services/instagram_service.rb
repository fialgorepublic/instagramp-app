require 'net/http'
require 'json'

class InstagramService

  def self.initialize_downloads(tag, limit)
    uri = URI "https://www.instagram.com/explore/tags/#{tag}/?__a=1"
    headers = {
      'X-Requested-With' => 'XMLHttpRequest',
      'User-Agent' => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0"
    }
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    response = http.get(uri, headers)
    instagram_tag = response.body
    hashtag_json = JSON.parse(instagram_tag)
    hashtag_info = hashtag_json['graphql']['hashtag']
    edges = hashtag_info["edge_hashtag_to_media"]['edges']
    edges.first(limit).each_with_index do |edge, index|
      @post = Post.create(title: edge["node"]["edge_media_to_caption"]["edges"].first["node"]["text"], image_url: edge["node"]["display_url"])
    end
  end

end

