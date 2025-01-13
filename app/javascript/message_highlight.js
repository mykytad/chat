const initializeHighlighting = () => {
  const messagesDiv = document.getElementById("messages");

  if (!messagesDiv) return;

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
      setTimeout(removeHashFromURL, 1500);
    }
  };

  const initializeLinks = () => {
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
      anchor.addEventListener("click", (event) => {
        event.preventDefault(); // Предотвращаем стандартное поведение

        const hash = anchor.getAttribute("href");
        const targetElement = document.querySelector(hash);

        if (targetElement) {
          targetElement.scrollIntoView({ behavior: "smooth", block: "start" });
          setTimeout(() => handleAnchorClick(anchor), 100);
        }
      });
    });
  };

  // Обработка текущего хэша при загрузке страницы
  const hash = window.location.hash;
  if (hash) {
    const targetElement = document.querySelector(hash);
    if (targetElement) {
      applyHighlight(targetElement);
      setTimeout(removeHashFromURL, 1500);
    }
  }

  // Инициализация ссылок
  initializeLinks();
};

// Убедимся, что скрипт работает при разных сценариях загрузки страницы
document.addEventListener("DOMContentLoaded", initializeHighlighting);
document.addEventListener("turbo:load", initializeHighlighting);
