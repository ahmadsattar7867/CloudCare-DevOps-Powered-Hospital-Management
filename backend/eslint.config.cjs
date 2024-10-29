module.exports = [
  {
    ignores: ['node_modules/**', 'dist/**'],
  },
  {
    files: ['src/**/*.js'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
    },
    env: {
      node: true,
      jest: true,
    },
    rules: {
      // Add your specific rules here
    },
  },
];
