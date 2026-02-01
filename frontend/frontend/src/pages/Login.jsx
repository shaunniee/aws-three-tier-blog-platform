export default function Login() {
  const REDIRECT_URI = import.meta.env.VITE_CALLBACK_URL;
  const loginUrl = `${import.meta.env.VITE_COGNITO_DOMAIN}/login?` +
                 `response_type=token&` +
                 `client_id=${import.meta.env.VITE_COGNITO_CLIENT_ID}&` +
                 `redirect_uri=${encodeURIComponent(REDIRECT_URI)}`;
                 console.log("Login URL:", loginUrl);

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <button
        className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700"
        onClick={() => window.location.href = loginUrl}
      >
        Login with Cognito
      </button>
    </div>
  );
}