// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "../sweetalert/sweetalert";

import jQuery from "jquery";
import "@popperjs/core";
import Chartist from "chartist";
import SmoothScroll from "smooth-scroll";
import "@fortawesome/fontawesome-free/js/all.js";
import "select2";

// import "../volt/volt.js";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

require("trix");
require("@rails/actiontext");

window.$ = window.jQuery = jQuery;
window.bootstrap = require('bootstrap');
window.Chartist = Chartist;
window.SmoothScroll = SmoothScroll;

require('../volt/volt');

$(function () {

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
  $(".select2-rekenings").select2({
    width: "100%",
    theme: "bootstrap-5",
    ajax: {
      delay: 1000,
      url: '/rekening_search.json',
      data: (params) => ({ q: params.term })
    },
    language: {
      inputTooShort: function () {
        return "Input minimal 3 Karakter";
      }
    }
  });
  $("#select2-musrenbang").select2({
    width: "100%",
    theme: "bootstrap-5",
    ajax: {
      delay: 1000,
      url: '/musrenbang_search.json',
      data: (params) => ({ q: params.term })
    },
    language: {
      inputTooShort: function () {
        return "Input minimal 3 Karakter";
      }
    }
  });
  $('#form-perhitungan-body').on('show', function () {
    $(".select2-rekenings").select2({
      width: "100%",
      theme: "bootstrap-5",
      dropdownParent: $("#form-perhitungan"),
      ajax: {
        delay: 1000,
        url: '/rekening_search.json',
        data: (params) => ({ q: params.term })
      },
      language: {
        inputTooShort: function () {
          return "Input minimal 3 Karakter";
        }
      }
    });
    $(".select2-anggaran-ssh").select2({
      width: "100%",
      theme: "bootstrap-5",
      dropdownParent: $("#form-perhitungan"),
      ajax: {
        delay: 1000,
        url: '/anggaran_ssh_search.json',
        data: (params) => ({ q: params.term })
      },
      language: {
        inputTooShort: function () {
          return "Input minimal 3 Karakter";
        }
      }
    }).on('select2:opening', function (e) {
      $(this).data('select2').$dropdown.find(':input.select2-search__field').attr('placeholder', 'Ketik Untuk mencari')
    }).on('select2:select', function (e) {
      let data_barang = e.params.data.id;
      let data_spesifikasi = [];
      $.ajax({
        type: 'get',
        url: '/anggaran_spesifikasi_search.json',
        data: {
          q: data_barang
        },
        success: function (res) {
          if (res) {
            data_spesifikasi = res.results
            $("#spesifikasi").val(res.results[0].spesifikasi)
            $('#satuan').val(res.results[0].satuan)
            $('#harga').val(res.results[0].harga)
          }
        },
        error: function (er) {
          console.log(er)
        }
      })
    });
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
