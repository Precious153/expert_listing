# Expert Listing Dashboard & Feed

## How to Run It

To run this Flutter application locally:

1. Ensure you have the Flutter SDK installed and configured.
2. Clone or open the project directory (`expert_listing`).
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on your preferred emulator or connected device:
   ```bash
   flutter run
   ```

## Endpoints

The app communicates with a backend hosted at `https://expertlisting-60hz.onrender.com`. The key endpoints used by the feed and posts are:

* `GET /posts?page={page}&size={size}`: Fetches paginated posts.
* `POST /posts`: Creates a new post.
* `GET /posts/{postId}/comments`: Retrieves comments for a specific post.
* `POST /posts/{postId}/comments`: Adds a comment to a post.
* `POST /posts/{postId}/like`: Toggles the like status of a post.
* `DELETE /posts/{postId}`: Deletes a specific post.
* `POST /uploads/images`: Uploads an image to the server.
