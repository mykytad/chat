document.addEventListener("turbo:load", () => {
  const replyClearButton = document.querySelector("#clear-reply");
  const messageWindow = document.querySelector("#messages"); // Target the message window element

  if (replyClearButton) {
    replyClearButton.addEventListener("click", (event) => {
      event.preventDefault(); // Prevent the default link behavior

      // Remove the replied_to_id parameter from the URL
      const url = new URL(window.location.href);
      url.searchParams.delete('replied_to_id'); // Delete the parameter from the query string
      history.replaceState(null, null, url.toString()); // Update the URL without reloading the page

      // Clear reply block and input
      const replyBlock = document.querySelector(".reply_new");
      const repliedToInput = document.querySelector("input[name='message[replied_to_id]']");
      if (replyBlock) replyBlock.remove();
      if (repliedToInput) repliedToInput.value = "";

      // Update the style of the message window
      if (messageWindow) {
        messageWindow.style.height = ""; // Reset to default or remove the inline style
      }
    });
  }
});