export async function apiFetch(path, options = {}) {
  const token = localStorage.getItem('idToken');

  const headers = {
    'Content-Type': 'application/json',
    ...options.headers,
  };

  if (token) {
    headers.Authorization = `Bearer ${token}`;
  }

  const res = await fetch(
    `${import.meta.env.VITE_API_BASE_URL}${path}`,
    { ...options, headers }
  );

  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.message || 'API error');
  }

  return res.json();
}