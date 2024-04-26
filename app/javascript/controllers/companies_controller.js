import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static targets = [ 'companyField' ];
  
  connect() {
    if (this.hasCompanyFieldTarget) {
      this.enableTS();
    }
  }

  disconnect() {
   
  }

  enableTS() {
    new TomSelect(this.companyFieldTarget, {
      plugins: {
        remove_button:{
          title:'Remove this item',
        }
      },
  		onItemAdd:function(){
  			this.setTextboxValue('');
  			this.refreshOptions();
  		},
      persist: false,
      create: async function(input, callback) {
        const data = { company: { name: input } }
        let response = await fetch('/companies', {
          method: 'POST',
          headers:  {
            "X-CSRF-Token": Rails.csrfToken(),
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: JSON.stringify(data)
        })
        let newCompany = await response.json();

        return await callback({ value: newCompany.id, text: newCompany.name })
      }
    })

    
  }
}
