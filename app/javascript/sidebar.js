document.addEventListener("turbo:load", () => {
  // Check if the sidebar exists on the page
  const sidebar = document.getElementById('sidebar');
  
  if (sidebar) {
    console.log('Sidebar found!');

    // Functions for managing the sidebar
    function showSidebar() {
      var backArrow = document.getElementById('back-arrow');
      var sidebar = document.querySelector('.sidebar');
      var sidebarCross = document.getElementById('sidebar-cross');
      var dialoguesDisplay = document.querySelector('.dialogues-display');

      backArrow.classList.add('d-none');
      dialoguesDisplay.classList.add('d-none');
      sidebar.classList.remove('d-none');
      sidebarCross.classList.remove('d-none');
    }

    function hideSidebar() {
      var backArrow = document.getElementById('back-arrow');
      var sidebar = document.querySelector('.sidebar');
      var sidebarCross = document.getElementById('sidebar-cross');
      var dialoguesDisplay = document.querySelector('.dialogues-display');

      backArrow.classList.remove('d-none');
      dialoguesDisplay.classList.remove('d-none');
      sidebar.classList.add('d-none');
      sidebarCross.classList.add('d-none');
    }

    // Add event listeners to buttons related to the sidebar
    const backArrow = document.getElementById('back-arrow');
    const sidebarCross = document.getElementById('sidebar-cross');

    if (backArrow) {
      backArrow.addEventListener('click', showSidebar);
    }

    if (sidebarCross) {
      sidebarCross.addEventListener('click', hideSidebar);
    }
  } else {
    console.log('Sidebar not found!');
  }
});
