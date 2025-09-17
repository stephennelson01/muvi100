module.exports = {
  content: ["./app/views/**/*.{erb,html}", "./app/helpers/**/*.rb", "./app/javascript/**/*.js"],
  theme: { extend: {} },
  plugins: [require('@tailwindcss/typography'), require('@tailwindcss/line-clamp')],
}
