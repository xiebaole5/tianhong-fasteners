/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./en.html", "./products.html", "./en-products.html"],
  theme: {
    extend: {
      colors: {
        primary: { DEFAULT: '#0d1b2a', light: '#1b263b', dark: '#060d13' },
        accent:  { DEFAULT: '#d4891a', light: '#f0a833', dark: '#a86612' },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Poppins', 'system-ui', 'sans-serif'],
      }
    }
  },
  plugins: [],
}
