Ruby script that allows to export soundcloud likes to csv or download liked tracks as mp3

## Instructions

- Install the following gems
  ```
  gem install soundcloud
  gem install whirly # shows progress in terminal
  ```

Run the script with one of the following commands:

```
ruby soundcloud_likes_export.rb username # both csv and download likes as mp3

ruby soundcloud_likes_export.rb username -csv # only save likes to csv

ruby soundcloud_likes_export.rb username -dl # only download all likes as mp3
```

Files will be saved to the folder from which the script was started.

*If CLIENT_ID key stops working, just replace it with a different one.*

Some of the tracks might be missing probably due to some privacy setting of the user who uploaded them or api key restrictions.
I noticed that some api keys allow access to certain songs and others return nil or empty data.
