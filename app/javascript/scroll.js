// Function to check if the user is close enough to the bottom of the container
function shouldScrollToBottom() {
  const messagesContainer = document.getElementById('messages');
  if (!messagesContainer) return false;
  const scrollPosition = messagesContainer.scrollTop + messagesContainer.clientHeight;
  const scrollThreshold = messagesContainer.scrollHeight - 80; // 80px from the bottom
  return scrollPosition >= scrollThreshold;
}

document.addEventListener('turbo:load', function () {
  const messagesContainer = document.getElementById('messages');

  // Function to scroll the container to the bottom
  function scrollToBottom() {
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  }

  // Scroll to the bottom immediately when the page loads if close enough
  if (shouldScrollToBottom()) {
    scrollToBottom();
  }

  // Scroll to the bottom when the content in the messages container changes
  document.addEventListener('turbo:stream-render', function (event) {
    if (event.target && event.target.id === 'messages' && shouldScrollToBottom()) {
      scrollToBottom();
    }
  });
});

// Use window for global scope to avoid re-declaring observer
if (typeof window.observer === 'undefined') {
  window.observer = new MutationObserver(function () {
    const messagesContainer = document.getElementById('messages');
    if (messagesContainer && shouldScrollToBottom()) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  });

  const messagesElement = document.getElementById('messages');
  if (messagesElement) {
    window.observer.observe(messagesElement, { childList: true });
  }
} else {
  // If the variable already exists, update the observer
  window.observer.disconnect();
  const messagesElement = document.getElementById('messages');
  if (messagesElement) {
    window.observer.observe(messagesElement, { childList: true });
  }
}