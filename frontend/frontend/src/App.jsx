import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Login from './pages/Login';
import CreatePost from './pages/CreatePost';
import MyPosts from './pages/MyPosts';
import { useEffect } from 'react';

export default function App() {
   useEffect(() => {
    if (window.location.hash.includes('id_token')) {
      // Parse hash fragment
      const hash = window.location.hash.substring(1); // remove #
      const params = new URLSearchParams(hash);
      const idToken = params.get('id_token');
      const accessToken = params.get('access_token');

      // Save tokens
      localStorage.setItem('idToken', idToken);
      localStorage.setItem('accessToken', accessToken);

      // Clear the hash from URL
      window.location.hash = '';

      // Optional: redirect to Home or other route
      window.history.replaceState({}, document.title, '/');
    }
  }, []);

  return (
    <BrowserRouter>
      <Navbar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/login" element={<Login />} />
        <Route path="/create" element={<CreatePost />} />
        <Route path="/myposts" element={<MyPosts />} />
      </Routes>
    </BrowserRouter>
  );
}