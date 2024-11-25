# YouTube Live Chat Terminal (ylct)

To view a YouTube streams chat messages in your terminal. 

## Notes 

- [Request live chat messages](https://gist.github.com/w3cj/4f1fa02b26303ae1e0b1660f2349e705#3-request-live-chat-messages-using-this-activelivechatid)
- [Java Youtube API](https://developers.google.com/youtube/v3/quickstart/java)


## Get the Live event

1. Find Channel id through channel name:

```
curl 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&q={channel_name}&key={api_key}&type=channel'
```

2. Get live events with channel id

```
curl 'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId={channel_id}&eventType=live&type=video&key={api_key}'
```

Look for the videoId. 

In this case we get:   PCcudEmHDmo

3. Use live video id to get live streaming details: 

```
https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails,snippet&id={live_video_id}&key={api_key}
```

Then snippet.liveStreamingDetails.activeLiveChatId is what we want. In this case: 

Cg0KC1BDY3VkRW1IRG1vKicKGFVDclBzZVlMR3BOeWdWaTM0UXBHTnFwQRILUENjdWRFbUhEbW8 

4. Requestion live chat messages: 

```
curl 'https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId={live_chat_id}&part=snippet,authorDetails&maxResults=2000&key={api_key}'
```

5. You can use the `pollingIntervalMillis` and the `nextPageToken` in the response to poll the API for new chat messages. This are found in the most latest response.

in this case, nextPageToken is: 

GIOoq52n9okDIIWUnqWn9okD

```
curl 'https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId={live_chat_id}&part=snippet,authorDetails&maxResults=2000&pageToken={page_token}&key={api_key}'
```




