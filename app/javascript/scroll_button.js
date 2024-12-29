document.addEventListener('turbo:load', () => {
  const scrollDownArrow = document.querySelector('.scrol-down-arrow');
  const msgDisplay = document.querySelector('.msg-display');
  const downPoint = document.getElementById('down-point');

  // Scroll to down-point on arrow click
  scrollDownArrow.addEventListener('click', () => {
    downPoint.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'start' });
  });

  // Scroll when the window is resized
  window.addEventListener('resize', () => {
    downPoint.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'start' });
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const messageWindow = document.querySelector(".message_window");
  const scrollDownArrow = document.querySelector(".scrol-down-arrow");

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