import { Controller } from 'stimulus'

export default class extends Controller {
        static targets = ['table', 'row', 'cancel', 'form']
        static values = {
                anggaran: Number
        }

        simpan() {
                const form = this.formTarget.querySelector('form')
                form.submit()
        }

        appendForm() {
                const target = event.currentTarget
                const row_anggaran = target.parentElement.parentElement
                const simpan_btn = target.nextElementSibling
                const cancel_btn = simpan_btn.nextElementSibling
                const hapus_btn = cancel_btn.nextElementSibling
                const anggaran_col = row_anggaran.querySelector('[data-editable-table-target="row"]')

                const new_td = document.createElement('td')
                new_td.setAttribute('data-editable-table-target', 'form')
                // insert blank td
                row_anggaran.insertBefore(new_td, target.parentElement)
                this.formFetcher(target.href, new_td)
                // add clause if the form not success fetch
                anggaran_col.classList.add('d-none')
                target.classList.add('d-none')
                hapus_btn.classList.add('d-none')
                simpan_btn.classList.remove('d-none')
                cancel_btn.classList.remove('d-none')
        }

        formFetcher(url, location) {
                fetch(url)
                        .then((res) => res.text())
                        .then((html) => {
                                location.innerHTML = html
                        });
        }

        cancelForm() {
                const target = event.currentTarget
                const simpan_btn = target.previousElementSibling
                const hapus_btn = target.nextElementSibling
                const edit_btn = simpan_btn.previousElementSibling
                const row_anggaran = target.parentElement.parentElement
                const anggaran_col = row_anggaran.querySelector('[data-editable-table-target="row"]')
                target.classList.add('d-none')
                simpan_btn.classList.add('d-none')
                edit_btn.classList.remove('d-none')
                hapus_btn.classList.remove('d-none')
                anggaran_col.classList.remove('d-none')
                anggaran_col.nextElementSibling.remove()
        }
}


