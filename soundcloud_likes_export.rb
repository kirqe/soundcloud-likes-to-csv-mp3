# add a new app at http://soundcloud.com/you/apps and get your CLIENT_ID

require 'soundcloud'
require 'open-uri'
require 'csv'
require 'whirly'

CLIENT_ID = "a3e059563d7fd3372b49b37f00a00bcf" # Client ID of created app
username = ARGV[0] # Your username

return if username.nil?

page_size = 200
@res = []
@client = SoundCloud.new(:client_id => CLIENT_ID)
tracks = @client.get("/users/#{username}/favorites", limit: page_size, order: 'created_at', linked_partitioning: 1)

loop do
  if tracks.next_href
    @res += tracks.collection
    tracks = @client.get(tracks.next_href)
  else
    @res += tracks.collection
    break
  end
end

# save all tracks to csv likes.csv
def export_csv(tracks)
  CSV.open("likes.csv", 'wb') do |csv|
    tracks.uniq.each do |track|
      csv << [track.title, track.permalink_url]
    end
  end
end

def format_name(name)
  replacements = [ ["/", "-"], ["!", ""] ]
  replacements.each { |r| name.gsub!(r[0], r[1]) }
  name
end

def download_track(track_id, name)
  Dir.mkdir("likes") unless Dir.exists?("likes")

  track_path = "./likes/#{format_name(name)}.mp3"

  unless File.exists?(track_path)
    url = @client.get("/tracks/#{track_id}/streams").http_mp3_128_url
    if url
      File.open(track_path, "wb") do |mp3|
        mp3 << open(url, 'rb').read
      end
    end
  end
  Whirly.status = "Downloaded #{name}"
end

# download all tracks to /likes folder
def batch_download
  tracks = @res.uniq.map { |track| [ track.id, track.title ] }
  threads = []
  Whirly.start spinner: "dots", status: "Downloading..." do
    tracks.each_slice(8) do |batch|
      batch.each do |track|
        threads << Thread.new { download_track(track[0], track[1]) }
      end
    end

    threads.each { |thread| thread.join }
  end
end

case
  when ARGV.include?("-csv")
    export_csv(@res)
  when ARGV.include?("-dl")
    batch_download
  else
    export_csv(@res)
    batch_download
end
