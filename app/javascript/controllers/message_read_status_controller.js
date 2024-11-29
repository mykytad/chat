import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"];

  connect() {
    console.log("Message Read Status Controller connected");

    // Создаем новый IntersectionObserver
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      threshold: 0.5 // Элемент будет считаться видимым, когда 50% его области попадает в зону видимости
    });

    // Наблюдаем за элементом
    this.messageTargets.forEach(message => {
      this.observer.observe(message);
    });
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        // Когда элемент стал видимым, обновляем его статус
        const messageId = entry.target.dataset.messageId;
        const dialogueId = entry.target.dataset.dialogueId;

        console.log("Message is in view, updating status:", messageId, dialogueId);

        this.markAsRead(messageId, dialogueId);
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
        console.log('Статус сообщения обновлен');
      } else {
        console.error('Ошибка при обновлении статуса');
      }
    })
    .catch(error => {
      console.error('Ошибка сети:', error);
    });
  }

  disconnect() {
    // Останавливаем наблюдение за элементами, когда контроллер отключается
    this.observer.disconnect();
  }
}
