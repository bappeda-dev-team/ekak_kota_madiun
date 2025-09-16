import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ["status"];
    static values = {
        url: String,
        status: String
    }
    // default interval: 5s | 5000ms
    connect() {
        if (this.statusValue == 'diproses' || this.statusValue == 'pending') {
            setInterval(this.fetchData, 5000, this.urlValue, this.element)
        }
    }

    fetchData(url, targetElement) {
        console.log("url: ", url)
        console.log("element: ", targetElement)
        fetch(url)
            .then((res) => res.text())
            .then((text) => {
                targetElement.innerHTML = text;
            })
            .catch((e) => {
                targetElement.innerHTML = "Terjadi Kesalahan";
            })
    }
}
