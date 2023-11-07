// app/javascript/packs/controllers/dynamic_form_controller.js

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["select", "selectNested", "dynamicField", "dynamicFieldNested"];

  connect() {
    this.toggleFields(); // Initial check
  }

  toggleFields() {
    this.dynamicFieldTargets.forEach((element, index) => {
      console.log(this.selectTarget.value)
      if (element.dataset.optionValue === this.selectTarget.value) {
        element.classList.remove("hidden");
      } else {
        element.classList.add("hidden");
      }
    });
  }

  toggleFieldsNested() {
    this.dynamicFieldNestedTargets.forEach((element, index) => {
      if (element.dataset.optionValue === this.selectNestedTarget.value) {
        element.classList.remove("hidden");
      } else {
        element.classList.add("hidden");
      }
    });
  }

}
