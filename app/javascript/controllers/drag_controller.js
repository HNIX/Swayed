import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  
  connect() {
    this.sortable = Sortable.create(this.element, {
        onEnd: this.end.bind(this)
    })
  }

  end(event) {
    let id = event.item.dataset.id
    let campaign_id = event.item.dataset.campaignId
    let data = new FormData()

    let url = this.data.get("url")
    url = url.replace(":id", id)
    url = url.replace(":campaign_id", campaign_id)

    data.append("position", event.newIndex + 1)

    Rails.ajax({
        url: url,
        type: 'PATCH',
        data: data
    })
  }

  
}