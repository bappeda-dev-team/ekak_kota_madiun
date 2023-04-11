import Rails from "@rails/ujs";
import { Controller } from 'stimulus'

export default class extends Controller {
        static targets = ['table', 'anggaran', 'penetapan', 'totalPenetapan', 'cancel', 'simpan', 'edit', 'hapus', 'form']
        static values = {
                anggaran: Number
        }

        appendForm() {
                const target = event.currentTarget
                const form_td = this.formTarget
                form_td.classList.remove('d-none')
                this.formFetcher(target.href, form_td)

                this.penetapanTarget.classList.add('d-none')
                this.editTarget.classList.add('d-none')
                this.hapusTarget.classList.add('d-none')
                this.simpanTarget.classList.remove('d-none')
                this.cancelTarget.classList.remove('d-none')
        }

        formFetcher(url, location) {
                fetch(url)
                        .then((res) => res.text())
                        .then((html) => {
                                location.innerHTML = html
                        });
        }

        simpan() {
                this.toggleButton()
                const form = this.formTarget.querySelector('form')
                Rails.fire(form, 'submit')
                this.formTarget.innerHTML = ''
        }

        cancelForm() {
                this.toggleButton()
                this.formTarget.innerHTML = ''
        }

        toggleButton() {
                this.cancelTarget.classList.add('d-none')
                this.simpanTarget.classList.add('d-none')
                this.editTarget.classList.remove('d-none')
                this.hapusTarget.classList.remove('d-none')
                this.penetapanTarget.classList.remove('d-none')
                this.formTarget.classList.add('d-none')
        }

        onPostSuccess(event) {
                const result = event.detail
                const [data, _status, _request] = result

                const { anggaran, total, parent } = data.results
                this.penetapanTarget.innerHTML = anggaran
                const totalPenetapan = document.getElementById(parent)
                totalPenetapan.innerHTML = total
        }
}


