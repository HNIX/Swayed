import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"];
  
  connect() {
    this.selectedField = '';
  }

  selectField(event) {
    this.selectedField = event.target.value;
  }

  insertField() {
    console.log(this.selectedField);
    console.log(this.textareaTarget);
    if (this.selectedField && this.textareaTarget) {
      const fieldText = `{{${this.selectedField}}}`;
      this.insertAtCursor(this.textareaTarget, fieldText);
    }
  }

  insertAtCursor(textarea, text) {
    const startPos = textarea.selectionStart;
    const endPos = textarea.selectionEnd;
    const beforeText = textarea.value.substring(0, startPos);
    const afterText = textarea.value.substring(endPos, textarea.value.length);

    textarea.value = beforeText + text + afterText;
    textarea.selectionStart = startPos + text.length;
    textarea.selectionEnd = startPos + text.length;
    textarea.focus();
  }
}

