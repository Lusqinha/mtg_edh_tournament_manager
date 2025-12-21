module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['DM Sans', 'sans-serif'],
      },
      colors: {
        theme: {
          base: '#222831',
          surface: '#393E46',
          primary: '#00ADB5',
          text: '#EEEEEE',
        }
      }
    },
  },
  plugins: [],
}
