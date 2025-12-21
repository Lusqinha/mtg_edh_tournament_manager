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
        sans: ['Ysabeau Infant', 'sans-serif'],
      },
      colors: {
        theme: {
          base: '#0d1117',
          surface: '#161b22',
          primary: '#238636', // GitHub Green for primary actions
          secondary: '#1f6feb', // GitHub Blue
          text: '#c9d1d9',
          muted: '#8b949e',
          border: '#30363d',
        },
        github: {
          canvas: {
            default: '#0d1117',
            subtle: '#161b22',
            inset: '#010409',
          },
          border: {
            default: '#30363d',
            muted: '#21262d',
          },
          fg: {
            default: '#c9d1d9',
            muted: '#8b949e',
            subtle: '#6e7681',
          },
          btn: {
            bg: '#21262d',
            hover: '#30363d',
            primary: {
              bg: '#238636',
              hover: '#2ea043',
            }
          }
        }
      }
    },
  },
  plugins: [],
}
