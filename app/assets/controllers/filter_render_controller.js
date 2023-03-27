import { Controller } from 'stimulus'

export default class extends Controller {
        static targets = ['results']

        append(event) {
                console.log('appended')
                const [_data, _status, xhr] = event.detail;
                // alert(status)
                this.resultsTarget.innerHTML = xhr.response
        }

        warning(event) {
                const [_data, status, _xhr] = event.detail;
                alert(status)
        }
}


