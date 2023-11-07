// field_name_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ 'input', 'error' ]

  validate() {
    let invalidChars = /[^a-z0-9_]/g;

    if (invalidChars.test(this.inputTarget.value.toLowerCase())) {
      this.inputTarget.classList.add('border', 'border-red-500');
      this.errorTarget.classList.remove('hidden');
      this.errorTarget.innerText = 'Can only be alphanumeric with underscores.';
    } else {
      this.inputTarget.classList.remove('border', 'border-red-500');
      this.errorTarget.classList.add('hidden');
      this.errorTarget.innerText = '';
    }
  }
}