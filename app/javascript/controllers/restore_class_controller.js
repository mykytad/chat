import { Controller } from "@hotwired/stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  static values = { userId: Number }

  connect() {
    this.userIdValue = this.element.dataset.currentUserId; // Получаем ID текущего пользователя из атрибута data-current-user-id
    console.log("Current user ID:", this.userIdValue); // Логируем ID пользователя для проверки
    this.subscribeToChannel(); // Подключаемся к DialogueChannel
    this.restoreActiveItem(); // Восстанавливаем активный элемент
    this.observeMutations(); // Наблюдаем за изменениями в списке диалогов
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe(); // Отписываемся от канала при отключении контроллера
    }
  }

  subscribeToChannel() {
    this.subscription = consumer.subscriptions.create(
      { channel: "DialogueChannel", user_id: this.userIdValue }, // Подключаемся к DialogueChannel с ID текущего пользователя
      {
        received: data => {
          console.log("Received data from Action Cable:", data); // Логируем полученные данные
          const dialogueElement = this.element.querySelector(`[data-dialogue-id="${data.dialogueId}"]`); // Ищем элемент диалога по ID
          if (dialogueElement) {
            dialogueElement.dataset.unreadMessages = data.unreadMessages; // Обновляем количество непрочитанных сообщений
            this.toggleUnreadBadge(dialogueElement); // Обновляем бейдж непрочитанных сообщений
          }
        }
      }
    );
    console.log("Subscribed to DialogueChannel:", this.userIdValue); // Логируем успешную подписку
  }

  restoreActiveItem() {
    const activeId = this.element.dataset.paramsDialogueId; // Получаем ID активного диалога из атрибута data-params-dialogue-id
    if (activeId) {
      this.element.querySelectorAll("li").forEach(item => {
        if (item.dataset.dialogueId === activeId) {
          item.classList.add("list_active_item"); // Добавляем класс активности для выбранного диалога
        } else {
          item.classList.remove("list_active_item"); // Убираем класс активности с других диалогов
        }
        this.toggleUnreadBadge(item); // Обновляем бейдж для каждого элемента
      });
    }
  }

  observeMutations() {
    const observer = new MutationObserver(() => this.restoreActiveItem()); // Создаем наблюдатель для отслеживания изменений
    observer.observe(this.element, { childList: true, subtree: true }); // Наблюдаем за изменениями в списке диалогов
  }

  toggleUnreadBadge(item) {
    const unreadCount = parseInt(item.dataset.unreadMessages, 10); // Парсим количество непрочитанных сообщений
    const badge = item.querySelector(".unread_badge"); // Находим элемент бейджа
    if (badge) {
      if (unreadCount > 0) {
        badge.classList.remove("d-none"); // Показываем бейдж, если есть непрочитанные сообщения
        badge.textContent = unreadCount; // Обновляем текст бейджа
      } else {
        badge.classList.add("d-none"); // Скрываем бейдж, если нет непрочитанных сообщений
        badge.textContent = ""; // Очищаем текст бейджа
      }
    }
  }
}
