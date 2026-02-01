import { useState } from 'react';
import { apiFetch } from '../api/client';

export default function CreatePost() {
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [file, setFile] = useState(null);

  const token = localStorage.getItem('idToken');

  async function submit(e) {
    e.preventDefault();

    let imageUrl = null;
    if (file) {
      const form = new FormData();
      form.append('file', file);

      const res = await fetch(`${import.meta.env.VITE_API_BASE_URL}/upload`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${token}` },
        body: form,
      });
      const data = await res.json();
      imageUrl = data.url;
    }

    await apiFetch('/posts', {
      method: 'POST',
      body: JSON.stringify({ title, content, image_url: imageUrl }),
      headers: { Authorization: `Bearer ${token}` },
    });

    alert('Post created');
    window.location.href = '/';
  }

  if (!token) return <p className="text-center mt-10">Please login to create a post</p>;

  return (
    <div className="max-w-xl mx-auto mt-10 bg-white p-6 rounded shadow">
      <h1 className="text-2xl font-bold mb-4">Create Post</h1>
      <form className="space-y-4" onSubmit={submit}>
        <input
          className="w-full border p-2 rounded"
          placeholder="Title"
          value={title}
          onChange={e => setTitle(e.target.value)}
        />
        <textarea
          className="w-full border p-2 rounded"
          placeholder="Content"
          value={content}
          onChange={e => setContent(e.target.value)}
        />
        <input
          type="file"
          onChange={e => setFile(e.target.files[0])}
        />
        <button
          type="submit"
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          Create Post
        </button>
      </form>
    </div>
  );
}