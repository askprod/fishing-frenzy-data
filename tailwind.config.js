const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
    content: [
      "./app/views/**/*.html.erb",
      "./app/helpers/**/*.rb",
      "./app/javascript/**/*.js"
    ],
    safelist: [
      "bg-gray-200", "text-gray-800",
      "bg-blue-200", "text-blue-800",
      "bg-yellow-200", "text-yellow-800",
      "bg-amber-200", "text-amber-800",
      "bg-pink-200", "text-pink-800",
      "bg-purple-200", "text-purple-800",
      "bg-cyan-200", "text-cyan-800",
      "bg-red-200", "text-red-800",
      "bg-orange-200", "text-orange-800",
      "bg-purple-200", "text-purple-800",
      "bg-fuchsia-200", "text-fuchsia-800",
      "bg-stone-200", "text-stone-800",
    ],
    theme: {
      extend: {},
    },
    plugins: [],
  };
  