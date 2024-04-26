import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "field"]

    removeValue(event) {
      event.preventDefault();
      event.stopPropagation();
      event.target.closest('[data-list-values-target="field"]').remove();
    }
  }