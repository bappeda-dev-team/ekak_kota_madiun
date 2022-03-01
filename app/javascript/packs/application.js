// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "./sweetalert";

import jQuery from "jquery";
import Swal from "sweetalert2";
import "@popperjs/core";
import Chartist from "chartist";
import SmoothScroll from "smooth-scroll";
import "../volt/volt.js";
import "@fortawesome/fontawesome-free/css/all";
import "select2";
import "select2/dist/css/select2.css";
import List from "list.js";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

require("trix");
require("@rails/actiontext");

window.$ = window.jQuery = jQuery;
window.bootstrap = require("bootstrap");
window.Chartist = Chartist;
window.SmoothScroll = SmoothScroll;

const tooltip = require("chartist-plugin-tooltips");

$(function () {
  console.log("javascript application is on");
  $("#dropdown").select2({
    width: "100%",
    theme: "bootstrap-5",
  });
  $(".select2-waw").select2({
    width: "100%",
    theme: "bootstrap-5",
  });
  $(".select2-sasaran").select2({
    width: "100%",
    theme: "bootstrap-5",
    language: {
      noResults: function () {
        return 'Sasaran Tidak Ditemukan';
      },
    },
  });
  $('#form-tematik-body').on('show', function () {
    $(".select2-tematik").select2({
      width: "100%",
      theme: "bootstrap-5",
      dropdownParent: $("#form-tematik"),
      language: {
        noResults: function () {
          return 'Tematik Tidak Ditemukan';
        },
      },
    })
  });
});
