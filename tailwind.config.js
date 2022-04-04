const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    "./views/*.{slim,erb}",
  ],
  theme: {
    fontSize: {
      'xs':   ['.75rem',   '1rem'],
      'sm':   ['.875rem',  '1.25rem'],
      'base': ['1.125rem', '2rem'],
      'lg':   ['1.25rem',  '2.25rem'],
      'xl':   ['1.5rem',   '2.25rem'],
      '2xl':  ['3rem',     '7rem']
    },
    fontFamily: {
      sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      mono: ['Fira Code', ...defaultTheme.fontFamily.mono],
    },
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
