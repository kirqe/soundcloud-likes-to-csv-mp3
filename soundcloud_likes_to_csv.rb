# add a new app at http://soundcloud.com/you/apps and get your CLIENT_ID

require 'soundcloud'
require 'csv'

CLIENT_ID = "YOUR_CLIENT_ID" # Client ID of created app
USERNAME = "USERNAME" # your username

page_size = 200
res = []
client = SoundCloud.new(:client_id => CLIENT_ID)
tracks = client.get("/users/#{USERNAME}/favorites", limit: page_size, order: 'created_at', linked_partitioning: 1)

loop do
  if tracks.next_href
    res += tracks.collection
    tracks = client.get(tracks.next_href)
  else
    res += tracks.collection
    break
  end
end

CSV.open("likes.csv", 'wb') do |csv|
  res.uniq.each do |track|
    csv << [track.title, track.permalink_url]
  end
end
