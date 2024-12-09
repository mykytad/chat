document.addEventListener("DOMContentLoaded", () => {
  const messagesDiv = document.getElementById("messages");

  if (messagesDiv) {
    const applyHighlight = (element) => {
      element.classList.add("highlight");

      setTimeout(() => {
        element.classList.remove("highlight");
      }, 1000);
    };

    const removeHashFromURL = () => {
      history.replaceState(null, null, " ");
    };

    const handleAnchorClick = (anchor) => {
      const hash = anchor.getAttribute("href");
      const targetElement = document.querySelector(hash);
      if (targetElement) {
        applyHighlight(targetElement);
        // Remove the hash from the URL after 1.5 seconds
        setTimeout(removeHashFromURL, 1500);
      }
    };

    // Handle the current hash when the page loads
    const hash = window.location.hash;
    if (hash) {
      const targetElement = document.querySelector(hash);
      if (targetElement) {
        applyHighlight(targetElement);
        setTimeout(removeHashFromURL, 1500);
      }
    }

    // Add click handlers to all anchor links
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
      anchor.addEventListener("click", (event) => {
        event.preventDefault(); // Prevent default browser behavior
        const hash = anchor.getAttribute("href");
        const targetElement = document.querySelector(hash);

        if (targetElement) {
          // Scroll to the target element manually
          targetElement.scrollIntoView({ behavior: "smooth", block: "start" });

          // Apply highlight and remove hash
          setTimeout(() => handleAnchorClick(anchor), 100);
        }
      });
    });
  }
});
