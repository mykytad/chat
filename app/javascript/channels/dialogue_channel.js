import consumer from "./consumer"

consumer.subscriptions.create("DialogueChannel", {
  connected() {
    console.log("connected to DialogueChannel");
  },

  received(data) {
    console.log("received data from DialogueChannel:", data);
  },

  disconnected() {
    console.log("disconnected from DialogueChannel");
  }
})
