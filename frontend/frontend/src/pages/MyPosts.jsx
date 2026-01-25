import { useEffect, useState } from "react";

export default function MyPosts() {
  const [posts, setPosts] = useState([]);
  const [editPost, setEditPost] = useState(null); // post being edited
  const [error, setError] = useState(null);
  const token = localStorage.getItem("idToken");

  // Fetch user posts
  const fetchPosts = async () => {
    if (!token) return;
    try {
      const res = await fetch(`${import.meta.env.VITE_API_BASE_URL}/posts/me`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (!res.ok) throw new Error("Failed to fetch posts");
      const data = await res.json();
      setPosts(data);
    } catch (err) {
      console.error(err);
      setError("Failed to load your posts");
    }
  };

  useEffect(() => {
    fetchPosts();
  }, [token,posts]);

  // Handle Delete
  const handleDelete = async (postId) => {
    if (!postId) return alert("Invalid post ID");

    const confirmed = window.confirm("Are you sure you want to delete this post?");
    if (!confirmed) return;

    try {
      const res = await fetch(`${import.meta.env.VITE_API_BASE_URL}/posts/${postId}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      });

      if (!res.ok) throw new Error("Delete failed");

      // Update state
      setPosts((prevPosts) => prevPosts.filter((p) => p.id !== postId));
    } catch (err) {
      console.error(err);
      alert("Failed to delete post");
    }
  };

  // Handle Edit
  const handleEdit = (post) => setEditPost(post);

  const handleUpdate = async (e) => {
    e.preventDefault();
    const { post_id, title, description, image_url } = editPost;

    try {
      const res = await fetch(`${import.meta.env.VITE_API_BASE_URL}/posts/${post_id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ title, description, image_url }),
      });
      if (!res.ok) throw new Error("Update failed");

      const updatedPost = await res.json();

      // Update post in state
      setPosts((prev) => prev.map((p) => (p.id === updatedPost.id ? updatedPost : p)));
      setEditPost(null); // close modal
    } catch (err) {
      console.error(err);
      alert("Failed to update post");
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setEditPost((prev) => ({ ...prev, [name]: value }));
  };

  if (!token)
    return <p className="text-center mt-10">Please login to view your posts</p>;

  return (
    <div className="bg-gray-100 min-h-screen p-6">
      <h1 className="text-3xl font-bold mb-6 text-center">My Posts</h1>
      {error && <p className="text-red-500 text-center mb-4">{error}</p>}

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {posts.length === 0 && !error && (
          <p className="text-gray-500 col-span-full text-center">
            You haven’t created any posts yet.
          </p>
        )}

        {posts.map((post) => (
          <div key={post.id} className="bg-white rounded-lg shadow-md p-6 flex flex-col">
            <h2 className="text-xl font-semibold text-gray-800 mb-2">{post.title}</h2>
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
            <div className="mt-2 flex space-x-2">
              <button
                onClick={() => handleEdit(post)}
                className="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600"
              >
                Edit
              </button>
              <button
                onClick={() => handleDelete(post.post_id)}
                className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
              >
                Delete
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* Edit Post Modal */}
      {editPost && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <form
            className="bg-white p-6 rounded shadow w-96"
            onSubmit={handleUpdate}
          >
            <h2 className="text-xl font-bold mb-4">Edit Post</h2>
            <input
              type="text"
              name="title"
              value={editPost.title}
              onChange={handleChange}
              className="w-full mb-2 p-2 border rounded"
              placeholder="Title"
              required
            />
            <textarea
              name="description"
              value={editPost.description}
              onChange={handleChange}
              className="w-full mb-2 p-2 border rounded"
              placeholder="Content"
              required
            />
            <input
              type="text"
              name="image_url"
              value={editPost.image_url || ""}
              onChange={handleChange}
              className="w-full mb-4 p-2 border rounded"
              placeholder="Image URL"
            />
            <div className="flex justify-end space-x-2">
              <button
                type="button"
                onClick={() => setEditPost(null)}
                className="px-3 py-1 rounded bg-gray-300 hover:bg-gray-400"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="px-3 py-1 rounded bg-blue-500 text-white hover:bg-blue-600"
              >
                Save
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}