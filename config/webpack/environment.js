const { environment } = require('@rails/webpacker')
const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({
  // $: 'jquery',
  // jQuery: 'jquery',
  // Popper: ['popper.js', 'default'],
  // Swal: 'sweetalert2',
  // SmoothScroll: 'smooth-scroll',
  // bootstrap: 'bootstrap',
  // Chartist: 'chartist'
})
)

module.exports = environment
