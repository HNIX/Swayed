import { Controller } from "@hotwired/stimulus"
import Tribute from "tributejs"
import Trix from "trix"

export default class FormulaController extends Controller {
  static targets = ["formulaInput"];

  connect() {
    this.editor = this.formulaInputTarget.editor
    this.initializeTribute()

    this.removeTrixToolbarElements(['text-tools', 'block-tools', 'file-tools']);
  }

  disconnect() {
    this.tribute.detach(this.formulaInputTarget)
  }

  removeTrixToolbarElements(toolGroups) {
    toolGroups.forEach(toolGroup => {
      const toolElement = document.querySelector(`[data-trix-button-group="${toolGroup}"]`);
      if (toolElement) {
        toolElement.remove();
      }
    });
  }

  initializeTribute() {
    this.tribute = new Tribute({
      allowSpaces: true,
      lookup: 'name',
      values: this.fetchFields,
      trigger: '{{',
    })
    this.tribute.attach(this.formulaInputTarget)
    this.tribute.range.pasteHtml = this._pasteHtml.bind(this)
    this.formulaInputTarget.addEventListener("tribute-replaced", this.replaced)
  }

  fetchFields(text, callback) {
    let campaign_id = document.querySelector("trix-editor").dataset.fieldsCampaign

    fetch(`/campaigns/${campaign_id}/fields.json?query=${text}`)
      .then(response => response.json())
      .then(fields => callback(fields))
      .catch(error => callback([]))
  }

  replaced(e) {
    let field = e.detail.item.original
    let attachment = new Trix.Attachment({
      sgid: field.sgid,
      content: field.content
    })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(" ")
  }

  _pasteHtml(html, startPos, endPos) {
    let position = this.editor.getPosition()
    this.editor.setSelectedRange([position - endPos + startPos, position + 1])
    this.editor.deleteInDirection("backward")
  }
}
