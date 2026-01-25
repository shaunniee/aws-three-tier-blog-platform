import { useEffect, useState } from 'react';
import { apiFetch } from '../api/client';

export default function Home() {
  const [posts, setPosts] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    apiFetch('/posts')
      .then(setPosts)
      .catch(() => setError('Failed to load posts'));
  }, []);

  return (
    <div className="bg-gray-100 min-h-screen p-6">
      <h1 className="text-4xl font-bold text-gray-800 mb-6 text-center">
        Blog Posts
      </h1>

      {error && <p className="text-red-500 text-center mb-4">{error}</p>}

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {posts.length === 0 && !error && (
          <p className="text-gray-500 col-span-full text-center">
            No posts yet.
          </p>
        )}

        {posts.map((post) => (
          <div
            key={post.id}
            className="bg-white rounded-lg shadow-md p-6 flex flex-col"
          >
            <h2 className="text-xl font-semibold text-gray-800 mb-2">
              {post.title}
            </h2>
            <p className="text-gray-600 mb-4">{post.description}</p>
            {post.image_url && (
              <img
                src={post.image_url}
                alt={post.title}
                className="rounded-md object-cover h-48 w-full mb-2"
              />
            )}
            <span className="text-gray-400 text-sm mt-auto">
              {new Date(post.created_at).toLocaleString()}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}