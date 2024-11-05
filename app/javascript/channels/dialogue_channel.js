import consumer from "./consumer"

consumer.subscriptions.create("DialogueChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
  }
})
