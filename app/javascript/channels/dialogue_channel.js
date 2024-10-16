import consumer from "channels/consumer"

document.addEventListener("turbo:load", () => {
  const userId = document.body.getAttribute('data-user-id');
  
  consumer.subscriptions.create({ channel: "DialogueChannel", user_id: userId }, {
    connected() {
      console.log(`Connected to WebSocket as user: ${userId}`);
    },

    disconnected() {
      console.log(`Disconnected from WebSocket`);
    },

    received(data) {
      console.log("Received:", data);
      // Обработка данных
    }
  });
});