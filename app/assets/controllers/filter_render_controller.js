import { Controller } from 'stimulus'

export default class extends Controller {
        static targets = ['results']

        append(event) {
                const [_data, _status, xhr] = event.detail;
                // alert(status)
                this.resultsTarget.innerHTML = xhr.response
        }

        warning(event) {
                const [_data, status, _xhr] = event.detail;
                alert(status)
        }

        success(event) {
                const [xhr, status] = event.detail
                const target = 'render-results'
                const element = document.getElementById(target)

                if (status == 'OK') {
                        const html = xhr.response
                        element.innerHTML = html
                }
                else {
                        const html = '<div class="alert alert-danger" role="alert">Terjadi Kesalahan</div>'
                        element.innerHTML = html
                }
        }
}
