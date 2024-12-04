document.addEventListener("turbo:load", () => {
  function showSidebar() {
    var backArrow = document.getElementById('back-arrow');
    var sidebar = document.querySelector('.sidebar');
    var sidebarCross = document.getElementById('sidebar-cross');
    var msgDisplay = document.querySelector('.msg-display');

    backArrow.classList.add('d-none');
    msgDisplay.classList.add('d-none');
    sidebar.classList.remove('d-none');
    sidebarCross.classList.remove('d-none');
  }

  function hideSidebar() {
    var backArrow = document.getElementById('back-arrow');
    var sidebar = document.querySelector('.sidebar');
    var sidebarCross = document.getElementById('sidebar-cross');
    var msgDisplay = document.querySelector('.msg-display');

    backArrow.classList.remove('d-none');
    msgDisplay.classList.remove('d-none');
    sidebar.classList.add('d-none');
    sidebarCross.classList.add('d-none');
  }

  document.getElementById('back-arrow').addEventListener('click', showSidebar);
  document.getElementById('sidebar-cross').addEventListener('click', hideSidebar);
});