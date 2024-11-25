#!/bin/bash 

YOUTUBER="Ludwig"
API_KEY=${YT_API_KEY}
PAGE_TOKEN=""
POLL_INTERVAL=0

#Get the channel ID of the Youtuber
CHANNEL_ID=$(curl "https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=${YOUTUBER}&key=${API_KEY}&type=channel" | jq -r '.items[0].id.channelId')
echo "Obtained Channel ID of $YOUTUBER"

# Get the live video id 
VIDEO_ID=$(curl "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=${CHANNEL_ID}&eventType=live&type=video&key=${API_KEY}" | jq -r '.items[0].id.videoId')

if [ "$VIDEO_ID" == "null"]; then
    echo "$YOUTUBER is not live."
    exit 1
fi 

echo "Obtained Video id of livestream"

# Get the live chat id
LIVE_CHAT_ID=$(curl "https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails,snippet&id=${VIDEO_ID}&key=${API_KEY}" | jq -r '.items[0].liveStreamingDetails.activeLiveChatId')
echo "Obtained live chat ID"

# Continually grab chat messages
while true; do

    # Get messages
    RESPONSE=$(curl -s "https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId=${LIVE_CHAT_ID}&part=snippet,authorDetails&maxResults=2000&pageToken=${PAGE_TOKEN}&key=${API_KEY}")

    # Print the messages
    echo "$RESPONSE" | jq -r '.items[] | "\(.authorDetails.displayName): \(.snippet.displayMessage)"'

    # Grab the next page token and polling interval
    PAGE_TOKEN=$(echo "$RESPONSE" | jq -r '.nextPageToken')
    POLL_INTERVAL=$(echo "$RESPONSE" | jq -r '.pollingIntervalMillis')

    # Ensure the page token is valid
    if [ "$PAGE_TOKEN" == "null" ]; then
        echo "No more messages."
        break
    fi

    # Sleep for the polling interval before getting more messages 
    sleep $(($POLL_INTERVAL / 1000))

done

echo "Program finished executing"
