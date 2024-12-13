import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.restoreActiveItem();
    this.observeMutations();
  }

  restoreActiveItem() {
    const activeId = this.element.dataset.paramsDialogueId; // Текущий активный диалог ID
    if (activeId) {
      this.element.querySelectorAll("li").forEach(item => {
        if (item.dataset.dialogueId === activeId) {
          item.classList.add("list_active_item");
        } else {
          item.classList.remove("list_active_item");
        }
      });
    }
  }

  observeMutations() {
    const observer = new MutationObserver(() => this.restoreActiveItem());
    observer.observe(this.element, { childList: true, subtree: true });
  }
}
