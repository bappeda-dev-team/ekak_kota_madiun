// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Bootstrap 5 thing
import jQuery from 'jquery'
import Swal from 'sweetalert2'
import '@popperjs/core'
import Chartist from "chartist"
import bootstrap from "bootstrap"
// import './volt/volt.scss'
import './volt/volt.js'


import "@fortawesome/fontawesome-free/css/all"

window.$ = window.jQuery = jQuery

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})