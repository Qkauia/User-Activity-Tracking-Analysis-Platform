module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  daisyui: {
    themes: [
      {
        mytheme: {
          primary: "#00a8b5",

          secondary: "#00b649",

          accent: "#008e62",

          neutral: "#1c211d",

          "base-100": "#f5feff",

          info: "#00c6f4",

          success: "#00ffc5",

          warning: "#c02800",

          error: "#ff003a",
        },
      },
    ],
  },
};
