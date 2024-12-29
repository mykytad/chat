document.addEventListener('turbo:load', function () {
  const scrollDownArrow = document.querySelector('.scrol-down-arrow');
  const msgDisplay = document.querySelector('.msg-display');
  const downPoint = document.getElementById('down-point');
  const messagesContainer = document.getElementById('messages');
  const messageWindow = document.querySelector(".message_window");

  // Function to check if the user is at the bottom
  function isAtBottom() {
    if (!messagesContainer) return false;
    const scrollPosition = messagesContainer.scrollTop + messagesContainer.clientHeight;
    const threshold = messagesContainer.scrollHeight - 80; // 80px threshold from the bottom
    return scrollPosition >= threshold;
  }

  // Function to scroll to the bottom
  function scrollToBottom() {
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  }

  // Function to handle new messages with delay
  function handleNewMessage() {
    if (isAtBottom()) {
      // Add a delay to ensure the DOM is fully updated
      setTimeout(() => {
        scrollToBottom();
      }, 50); // Delay of 50ms
    }
  }

  // Scroll to down-point on arrow click
  scrollDownArrow.addEventListener('click', () => {
    downPoint.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'start' });
  });

  // Scroll when the window is resized
  window.addEventListener('resize', () => {
    downPoint.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'start' });
  });

  // Initial scroll to bottom
  scrollToBottom();

  // Event listener for Turbo Stream renders
  document.addEventListener('turbo:stream-render', function (event) {
    if (event.target.closest('#messages')) {
      handleNewMessage();
    }
  });

  // Ensure only one MutationObserver is active
  if (window.messagesObserver) {
    window.messagesObserver.disconnect();
  }

  // Create and configure a new observer
  if (messagesContainer) {
    window.messagesObserver = new MutationObserver(function () {
      handleNewMessage();
    });

    window.messagesObserver.observe(messagesContainer, { childList: true, subtree: true });
  }

  if (messageWindow && scrollDownArrow) {
    // Set the initial scroll position to the bottom
    messageWindow.scrollTop = messageWindow.scrollHeight;

    messageWindow.addEventListener("scroll", () => {
      const scrollOffset = messageWindow.scrollHeight - messageWindow.scrollTop - messageWindow.clientHeight;

      // Add or remove the .d-none class based on scroll position
      if (scrollOffset > 80) {
        scrollDownArrow.classList.remove("d-none");
      } else {
        scrollDownArrow.classList.add("d-none");
      }
    });
  }
});
