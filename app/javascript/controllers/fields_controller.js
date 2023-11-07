import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['field', 'delete']

  removeField(event) {    
    this.fieldTarget.remove();
  }

  deleteField(event) {    
    this.fieldTarget.classList.add('hidden');
    this.deleteTarget.value = 'true';
  }

  
}