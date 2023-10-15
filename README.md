# Convert MP4 to MPEG-DASH

- Receive a message via RabbitMQ informing which video should be converted

- Download the video to Google Cloud Storage

- Fragments the Video

- Convert Video to MPEG-DASH

- Upload the video to Google Cloud Storage

- Sends a notification via queue with information about the converted video or reporting an error in the conversion

- In case of error, the original message sent via RabbitMQ will be rejected and forwarded directly to a Dead Letter Exchange

## To Run
```docker compose up```

## To execute tests
```docker exec -it video-encoder-app-1 go test ./...```