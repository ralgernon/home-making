#!/usr/local/bin/bash
#
# Inspiration ---------------------------------------------
# I want a way to summon random bookmarks
# Ideally, a new one pops up whenever I start a new browser
#
# Manual/Docs Reading List--------------------------------- 
# bash, json, mozlz4-linux, jq, sed, ls, echo, read, head, shuff
#
# Setup ---------------------------------------------------
# Download script and save to wherever, I have it in my 
# projects folder.
# Run `chmod +x <wherever you saved the file>/bookmark-loader.sh` to allow it to run.
# Open your ~/.bashrc, and somewhere add the following lines:
# export random_url=https://www.wikipedia.com 
# skip including the octothorpe(#) because those are for comments
# It's probably a good idea to include a comment about what 
# the line is for. Just a "# bookmark-loader" before will do.
# Source your bash terminal
# `. ~/.bashrc` 
# Now if everything works out, you can run
# `. bookmark-loader.sh && firefox -new-tab $random_url` 
# If it works, a new random bookmark will load in your browser!!
#
# Todo ----------------------------------------------------
# ~ Check for repeats
# ~ Only load new bookmarks when needed
# ~ Convert at least some of the process to a cronjob
# ~ Prioritize bookmarks created on the current day
# ~ Blacklist websites
# ~ Files can get bookmarked too, sort those out
# ~ Mac & Windows compatibility so friends can use it too

# bash
bash="$HOME/.bashrc"

# we decide where to stash the bookmarks
bookmark_brain="$HOME/projects/bookmarks.json"

# let's keep track of which ones came up already
bookmark_hx="$HOME/projects/bookmark_shuffle_history.txt"

# check the most updated fancy mozilla json where firefox keeps our bookmarks
# jq parses the json and just gives us a list of websites to keep in our "brain"
~/mozlz4-linux -x "$(ls -t ~/.mozilla/firefox/*.default*/bookmarkbackups/* | head -n1)" | jq --raw-output '..|.uri? // empty' > "${bookmark_brain}"

# pick a random bookmark
read -r random_url < <(shuf "${bookmark_brain}")

# save the random bookmark to our history
echo "${random_url}" >> "${bookmark_hx}"

# change the environment variable
sed -i "s|export random_url=*\n|export random_url=$random_url|g" "${bash}"
