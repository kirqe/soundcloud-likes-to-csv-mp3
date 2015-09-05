# add a new app at http://soundcloud.com/you/apps and get your CLIENT_ID

require 'soundcloud'
require 'csv'

CLIENT_ID = "YOUR_CLIENT_ID" # Client ID of created app
USERNAME = "USERNAME" # your username


page_size = 50
client = SoundCloud.new(:client_id => CLIENT_ID)
res = []
tracks = client.get("/users/#{USERNAME}/favorites", limit: page_size, order: 'created_at', linked_partitioning: 1)

tracks.collection.each do |track|
  res << [track.title, track.permalink_url]
end

while tracks.next_href
  tracks = client.get(tracks.next_href)
  tracks.collection.each do |track|
    res << [track.title, track.permalink_url]
  end
end

CSV.open("likes.csv", 'wb') do |csv|
  res.each do |track|
    csv << track
  end
end


