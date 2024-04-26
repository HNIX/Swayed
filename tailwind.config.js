// See the Tailwind default theme values here:
// https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js
const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')


//const { getUltimateTurboModalPath } = require('ultimate_turbo_modal/gemPath')

const { execSync } = require('child_process');

function getUltimateTurboModalPath() {
  const path = execSync('bundle show ultimate_turbo_modal').toString().trim();
  return `${path}/**/*.{erb,html,rb}`;
}

/** @type {import('tailwindcss').Config */
module.exports = {
  darkMode: 'class',

  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],

  content: [
    './public/*.html',
    './app/components/**/*.rb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim,rb}',
    './lib/jumpstart/app/views/**/*.erb',
    './lib/jumpstart/app/helpers/**/*.rb',
    getUltimateTurboModalPath()
  ],

  // All the default values will be compiled unless they are overridden below
  theme: {
    // Extend (add to) the default theme in the `extend` key
    extend: {
      // Create your own at: https://javisperez.github.io/tailwindcolorshades
      colors: {
        primary: colors.blue,
        secondary: colors.emerald,
        tertiary: colors.gray,
        danger: colors.red,
        gray: colors.neutral,
        "code-400": "#fefcf9",
        "code-600": "#3c455b",
        zinc: colors.zinc,
        white: '#FEFEFE',
        beige: '#F1F1F1',
      },
      opacity: {
        '4': '.04',
      },
      backgroundImage: {
        'topography-pattern': "url('topography.svg')",
        'circuit-pattern': "url('circuit-board.svg')",
        'footer-texture': "url('texture.svg')",
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
    },
  },

  // Opt-in to TailwindCSS future changes
  future: {
  },
}
