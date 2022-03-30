
// Simple DataTable
import { DataTable } from 'simple-datatables';
const d = document;
d.addEventListener("DOMContentLoaded", function (event) {
  var dataTables = [].slice.call(d.querySelectorAll('[data-datatable]'))
  var dataTableList = dataTables.map(function (el) {
    el = new DataTable(el)
  });
});