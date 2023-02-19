// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "../javascript/channels";
import "../javascript/sweetalert/sweetalert";
import '../javascript/datatables/simple-datatables';

import jQuery from "jquery";
import "@popperjs/core";
// import Chartist from "chartist";
import SmoothScroll from "smooth-scroll";
import "@fortawesome/fontawesome-free/css/all";
import "select2";
import "vanilla-nested";
import 'simplebar';
import 'simplebar/dist/simplebar.css';

// pokin
import '../javascript/d3/index.js'
// images
require.context("../images", true);


Rails.start();
Turbolinks.start();
ActiveStorage.start();


window.$ = window.jQuery = jQuery;
window.bootstrap = require('bootstrap');
// window.Chartist = Chartist;
window.SmoothScroll = SmoothScroll;

require('../javascript/volt/volt');

import "controllers"
