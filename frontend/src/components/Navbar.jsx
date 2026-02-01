import { useEffect, useState } from "react";
import { Link } from "react-router-dom";

export default function Navbar() {
  const [token, setToken] = useState(localStorage.getItem("idToken"));

  useEffect(() => {
    if (window.location.hash.includes("id_token")) {
      const hash = window.location.hash.substring(1);
      const params = new URLSearchParams(hash);
      const idToken = params.get("id_token");
      if (idToken) {
        localStorage.setItem("idToken", idToken);

        // Wrap setState in a microtask to avoid sync update warning
        Promise.resolve().then(() => setToken(idToken));

        window.location.hash = "";
      }
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("idToken");
    setToken(null);
  };

  return (
    <nav className="bg-blue-600 text-white p-4 flex justify-between items-center">
      <div className="font-bold text-lg">
        <Link to="/">BlogApp</Link>
      </div>
      <div className="space-x-4">
        <Link to="/">Home</Link>
        {token ? (
          <>
            <Link to="/create">Create Post</Link>
            <Link to="/myposts">My Posts</Link>
            <button
              className="bg-red-500 px-2 py-1 rounded hover:bg-red-600"
              onClick={handleLogout}
            >
              Logout
            </button>
          </>
        ) : (
          <Link to="/login">Login</Link>
        )}
      </div>
    </nav>
  );
}