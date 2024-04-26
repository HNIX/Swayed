import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fieldGroup"]

  toggleFieldGroup(event) {
    this.fieldGroupTargets.forEach((element) => {
      
      if(element.dataset.fieldGroup === event.target.value) {
        element.classList.remove('hidden');
      } else {
        element.classList.add('hidden');
      }

    });
  }
}