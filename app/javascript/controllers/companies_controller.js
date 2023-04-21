import { Controller } from "@hotwired/stimulus"
import Rails from '@rails/ujs';
import TomSelect from "tom-select"


export default class extends Controller {
  static targets = [ 'sourceSelectField', 'companySelectField', 'newSourceForm', 'newCompanyForm', 'newCSForm', 'sourceNameField', 'companyNameField' ];
  
  connect() {
    if (this.hasSourceSelectFieldTarget) {
      this.enableSourceTS();
    }
    if (this.hasCompanySelectFieldTarget) {
      this.enableCompanyTS();
    }
  }

  disconnect() {
    const myModalEl = document.getElementById('company-modal');
    myModal.hide();
    const sourceForm = document.getElementById("new_source");
    myModalEl.addEventListener('hidden.bs.modal', function (event) {
    sourceForm.reset();
      Rails.enableElement(sourceForm);
    });
  }

  enableSourceTS() {
    const targets = this;

    new TomSelect(this.sourceSelectFieldTarget, {
      create: function(input, _callback) {
        console.log(input);
        console.log(this);
        
        targets.newCSFormTarget.classList.toggle('hidden');
        targets.newSourceFormTarget.classList.toggle('hidden');

        targets.sourceNameFieldTarget.value = input;
      }
    });
  }

  enableCompanyTS() {
    const targets = this;

    new TomSelect(this.companySelectFieldTarget, {
      create: function(input, _callback) {
        targets.newSourceFormTarget.classList.toggle('hidden');
        targets.newCompanyFormTarget.classList.toggle('hidden');

        targets.companyNameFieldTarget.value = input;
      }
    });
  }
}