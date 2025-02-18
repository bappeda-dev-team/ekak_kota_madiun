import { Controller } from "stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = ["tahun"];
  static values = {
    jenis: String,
    subJenis: String,
    eventName: { type: String, default: "change-select" },
    tipe: String,
    tahun: String,
    barang: String,
    perhitunganId: String,
    opd: String,
    rekening: String,
    parent: String,
    url: String,
    kodeOpd: String,
    kodeOpdTerpilih: Array,
    uraian: String,
    item: String,
    role: String,
    selected: String,
    display: { type: Boolean, default: true },
    width: { type: String, default: "element" },
  };

  get select() {
    return $(this.element);
  }

  get default_options() {
    let options = {
      width: "100%",
      theme: "bootstrap-5",
      dropdownParent: this.parentValue,
    };
    return options;
  }

  get element_options() {
    let width = this.widthValue;
    let options = {
      width: width,
      theme: "bootstrap-5",
    };
    return options;
  }

  get options_with_ajax() {
    let options = {
      width: "100%",
      theme: "bootstrap-5",
      dropdownParent: this.parentValue,
      ajax: {
        url: this.urlValue,
        data: (params) => ({
          kode_opd: this.kodeOpdValue,
          kode_opd_terpilih: this.kodeOpdTerpilihValue,
          jenis_rekening: this.rekeningValue,
          tahun: this.tahunValue,
          jenisUraian: this.tipeValue,
          role: this.roleValue,
          jenis: this.jenisValue,
          sub_jenis: this.subJenisValue,
          q: params.term,
        }),
        delay: 800,
      },
      cache: true,
    };
    return options;
  }

  get options_for_anggarans() {
    let options = {
      width: "100%",
      theme: "bootstrap-5",
      dropdownParent: this.parentValue,
      ajax: {
        url: this.urlValue,
        data: (params) => ({
          tahun: this.tahunValue,
          jenisUraian: this.tipeValue,
          barang_id: this.barangValue,
          q: params.term,
        }),
        delay: 800,
      },
      cache: true,
    };
    return options;
  }

  connect() {
    if (this.displayValue) {
      this.jenis_dropdown_generator();
    } else {
      this.element.style.display = "none";
    }
  }

  disconnect() {
    this.select.select2("destroy");
  }

  jenis_dropdown_generator() {
    let jenis = this.jenisValue;
    switch (jenis) {
      case "ajax":
        this.dropdown_base(this.options_with_ajax);
        break;
      case "extra":
        this.dropdown_with_action(this.options_with_ajax);
        break;
      case "tahun_anggaran":
        this.dropdown_tahun_anggaran(this.default_options);
        break;
      case "jenis_anggaran":
        this.dropdown_jenis_anggaran(this.options_with_ajax);
        break;
      case "uraian_anggaran":
        this.dropdown_uraian_anggaran(this.options_for_anggarans);
        break;
      case "chain":
        this.dropdown_with_action(this.default_options);
        break;
      case "element":
        this.dropdown_base(this.element_options);
        break;
      case "ajax_preselect":
        this.dropdown_ajax_preselect(this.options_with_ajax);
        break;
      default:
        this.dropdown_base(this.default_options);
    }
  }

  dropdown_base(options) {
    return this.select.select2(options).on("select2:open", () => {
      document.querySelector(".select2-search__field").focus();
    });
  }

  dropdown_tahun_anggaran(options) {
    const select2ed = this.dropdown_base(options);
    if (this.tahunValue.length > 0) {
      const text = this.tahunValue;
      const id = this.tahunValue;
      const options = new Option(text, id, true, true);
      select2ed.append(options);
    }
    const custom_name = this.eventNameValue;
    return select2ed.on("select2:select", (e) => {
      const custom_event = new CustomEvent(custom_name, {
        detail: { data: e.params.data },
      });
      document.dispatchEvent(custom_event);
    });
  }

  dropdown_uraian_anggaran(options) {
    const select2ed = this.dropdown_base(options);
    if (this.uraianValue.length > 0) {
      $.ajax({
        type: "GET",
        url: `/anggaran_ssh_find.json`,
        data: {
          perhitungan_id: this.perhitunganIdValue,
        },
      }).then(function (data) {
        const data_first = data.results[0];
        const options = new Option(data_first.text, data_first.id, true, true);
        select2ed.append(options);
        select2ed.trigger({
          type: "select2:select",
          params: {
            data: data_first,
          },
        });
      });
    }
    const custom_name = this.eventNameValue;
    return select2ed.on("select2:select", (e) => {
      const custom_event = new CustomEvent(custom_name, {
        detail: { data: e.params.data },
      });
      document.dispatchEvent(custom_event);
    });
  }

  dropdown_jenis_anggaran(options) {
    const select2ed = this.dropdown_base(options);
    if (this.tipeValue.length > 0) {
      $.ajax({
        type: "GET",
        url: `${this.urlValue}?q=${this.tipeValue}`,
      }).then(function (data) {
        const data_first = data.results[0];
        const options = new Option(data_first.text, data_first.id, true, true);
        select2ed.append(options);
        select2ed.trigger({
          type: "select2:select",
          params: {
            data: data_first,
          },
        });
      });
    }
    const custom_name = this.eventNameValue;
    return select2ed.on("select2:select", (e) => {
      const custom_event = new CustomEvent(custom_name, {
        detail: { data: e.params.data },
      });
      document.dispatchEvent(custom_event);
    });
  }

  dropdown_ajax_preselect(options) {
    // case "ajax_preselect":
    //   this.dropdown_ajax_preselect(this.options_with_ajax);
    const select2ed = this.dropdown_base(options);
    const item = this.itemValue;
    if (item.length > 0) {
      $.ajax({
        type: "GET",
        url: `${this.urlValue}?item=${this.itemValue}`,
      }).then(function (data) {
        const data_first = data.results.filter((data) => data.id == item)[0];
        const options = new Option(data_first.text, data_first.id, true, true);
        select2ed.append(options).trigger("change");
        select2ed.trigger({
          type: "select2:select",
          params: {
            data: data,
          },
        });
      });
    }
  }

  // custom_event
  dropdown_with_action(options) {
    let custom_event = "";
    const select2ed = this.dropdown_base(options);
    const custom_name = this.eventNameValue;
    if (this.hasSelectedValue) {
      const url = `${this.urlValue}?selected=${this.selectedValue}`
      $.ajax({
        type: "GET",
        url: url,
      }).then(function (data) {
        const data_first = data.results[0];
        const options = new Option(data_first.text, data_first.id, true, true);
        select2ed.append(options).trigger("change");
        select2ed.trigger({
          type: "select2:select",
          params: {
            data: data_first,
          },
        });
      });
    }
    select2ed.on("select2:select", (e) => {
      custom_event = new CustomEvent(custom_name, {
        detail: { data: e.params.data },
      });

      document.dispatchEvent(custom_event);
    });

  }

  // action

  fill_spesifikasi_satuan_harga(e) {
    const data_barang = e.detail.data;
    $("#perhitungan_barang_id").val(data_barang.barang_id);
    $("#spesifikasi").val(data_barang.spesifikasi);
    $("#satuan").val(data_barang.satuan);
    $("#harga").val(data_barang.harga);
    $("#uraian_barang").val(data_barang.uraian_barang);
    $("#spesifikasi").val(data_barang.spesifikasi);
    $("#satuan").val(data_barang.satuan);
    $("#harga_satuan").val(data_barang.harga);
  }

  fill_usulan_type(e) {
    $("input:hidden[name=usulan_type]").val(e.detail.data.usulan_type);
  }

  chain_value_to_target(e) {
    const opd_id = e.detail.data.id;
    this.kodeOpdValue = opd_id;
  }

  chain_internal_or_external_spbe(e) {
    const { data } = e.detail;
    const sasaranOpd = document.getElementById("sasaran-opd");
    if (data.id == "External") {
      this.roleValue = "";
      sasaranOpd.classList.add("d-none");
      this.select.empty().trigger("change");
    } else if (data.id == "Internal") {
      const select2ed = this.select;
      this.roleValue = "INTERNAL";
      if (this.kodeOpdValue.length > 0) {
        $.ajax({
          type: "GET",
          url: `${this.urlValue}?item=${this.kodeOpdValue}`,
        }).then(function (data) {
          const data_first = data.results[0];
          const options = new Option(
            data_first.text,
            data_first.id,
            true,
            true,
          );
          select2ed.append(options).trigger("change.select2");
        });
      }
      sasaranOpd.classList.remove("d-none");
      this.kodeOpdValue = this.kodeOpdValue;
    }
  }

  chain_internal_or_external_opd_target(e) {
    const { data } = e.detail;
    const sasaranOpd = document.getElementById("strategi_pohon_nip");
    if (data.id == "External") {
      sasaranOpd.setAttribute("disabled", "");
    } else {
      const select2ed = this.select;
      if (this.kodeOpdValue.length > 0) {
        $.ajax({
          type: "GET",
          url: `${this.urlValue}?item=${this.kodeOpdValue}`,
        }).then(function (data) {
          const data_first = data.results[0];
          const options = new Option(
            data_first.text,
            data_first.id,
            true,
            true,
          );
          select2ed.append(options).trigger("change.select2");
        });
      }
      sasaranOpd.removeAttribute("disabled", "");
      this.element.value = this.kodeOpdValue;
    }
  }

  chain_jenis_rekening_to_target(e) {
    const { data } = e.detail;
    const jenis_rek = data.id;
    this.rekeningValue = jenis_rek;
    this.select.select2("open");
  }

  chain_role_to_pelaksana(e) {
    const { data } = e.detail;
    const role = data.id;
    this.roleValue = role;
    this.select.select2("open");
  }

  chain_jenis_indikator(e) {
    const { data } = e.detail;
    const split = data.id.split(" ");

    const jenis = split[0];
    const sub_jenis = split[2];
    this.jenisValue = jenis;
    this.subJenisValue = sub_jenis;
    this.select.select2("open");
  }

  fill_tahun(e) {
    const { data } = e.detail;
    const tahun = data.id;
    this.tahunValue = tahun;
  }

  fill_jenis_uraian(e) {
    const { data } = e.detail;
    const jenisUraian = data.id;
    this.tipeValue = jenisUraian;
  }

  set_new_sasaran(e) {
    const { data } = e.detail;
    const sasaran_id = data.id;
    const select2ed = this.select;
    this.itemValue = sasaran_id;
    if (this.itemValue.length > 0) {
      $.ajax({
        type: "GET",
        url: `${this.urlValue}?item=${this.itemValue}`,
      }).then(function (data) {
        const data_first = data.results[0];
        const options = new Option(data_first.text, data_first.id, true, true);
        select2ed.append(options).trigger("change.select2");
      });
    }
    this.element.value = sasaran_id;
  }

  event_dispatcher(custom_event_name, data) {
    const custom_event = new CustomEvent(custom_event_name, {
      detail: { data: data },
    });
    document.dispatchEvent(custom_event);
  }
}
