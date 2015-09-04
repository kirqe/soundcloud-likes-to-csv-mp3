# add a new app at http://soundcloud.com/you/apps and get your CLIENT_ID

require 'soundcloud'
require 'csv'

CLIENT_ID = "YOUR_CLIENT_ID" # Client ID of created app
USERNAME = "USERNAME" # your username

client = SoundCloud.new(:client_id => CLIENT_ID)
tracks = client.get("/users/#{USERNAME}/favorites", :order => 'created_at DESC')

CSV.open('favorites.csv', "wb") do |csv|
  csv << ["Title", "URL"]
  tracks.each do |track|
    csv << [track.title, track.permalink_url]
  end
end
