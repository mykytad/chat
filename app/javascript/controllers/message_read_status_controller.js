import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"];

  connect() {
    console.log("Message Read Status Controller connected");

    // Create a new IntersectionObserver
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      threshold: 0.5 // The element will be considered visible when 50% of it is in the viewport
    });

    // Observe message elements
    this.messageTargets.forEach(message => {
      this.observer.observe(message);
    });
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        // When the element is in view, check if it has the 'read' class
        const messageElement = entry.target;
        const messageId = messageElement.dataset.messageId;
        const dialogueId = messageElement.dataset.dialogueId;

        // Check if it has the 'read' class
        if (!messageElement.classList.contains("read")) {
          console.log("Message is in view, updating status:", messageId, dialogueId);
          this.markAsRead(messageId, dialogueId);
        }
      }
    });
  }

  markAsRead(messageId, dialogueId) {
    fetch(`/dialogues/${dialogueId}/messages/${messageId}/read`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        dialogue_id: dialogueId,
        message_id: messageId
      }),
    })
    .then(response => {
      if (response.ok) {
        console.log('Message status updated');
      } else {
        console.error('Error updating message status');
      }
    })
    .catch(error => {
      console.error('Network error:', error);
    });
  }

  disconnect() {
    // Stop observing the elements when the controller is disconnected
    this.observer.disconnect();
  }
}
