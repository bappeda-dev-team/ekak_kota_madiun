import { Controller } from "stimulus";

export default class extends Controller {
    static values = {
        url: String,
        status: String
    }
    connect() {
        if (this.statusValue === "diproses" || this.statusValue === "pending") {
            this.timer = setInterval(() => {
                this.fetchData()
            }, 5000)
        }
    }

    disconnect() {
        // pastikan interval dibersihkan kalau element di-unload
        if (this.timer) {
            clearInterval(this.timer)
        }
    }

    fetchData() {
        fetch(this.urlValue, { headers: { Accept: "text/vnd.turbo-stream.html, text/html" } })
            .then((response) => response.text())
            .then((html) => {
                // replace isi element dengan partial baru
                this.element.innerHTML = html

                // ambil status baru dari dataset element hasil render
                const newStatus = this.element.dataset.pollingStatusValue
                this.statusValue = newStatus

                // guard: stop polling kalau status sudah final
                if (this.statusValue !== "signed" && this.statusValue !== "failed") {
                    clearInterval(this.timer)
                }
            })
            .catch((err) => console.error("Fetch error:", err))
    }
}
