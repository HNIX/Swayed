import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static targets = [ 'field', 'input', 'form' ];
  
  connect() {
    if (this.hasFieldTarget) {
      this.enableTS();
    }
  }

  disconnect() {

    this.formTarget.classList.add("hidden");
   
    const selectForm = document.getElementById("new_form");
    myModalEl.addEventListener('hidden.bs.modal', function (event) {
      selectForm.reset();
      Rails.enableElement(selectForm);
    });
  }

  enableTS() {
    const form = this.formTarget;
    const field = this.fieldTarget;

    new TomSelect(this.inputTarget, {
      plugins: {
        remove_button:{
          title:'Remove',
        }
      },
      create: function(input, _callback) {
        form.classList.toggle("hidden");
        field.classList.toggle("hidden");

        const name = document.getElementById('name_field');
        name.value = input;
      },
      sortField: {
        field: "text",
        direction: "asc"
      }
    });
  }
}
