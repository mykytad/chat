document.addEventListener("turbo:load", () => {
  function showSidebar() {
    const sidebar = document.querySelector(".sidebar");
    const msgDisplay = document.querySelector(".msg-display");
    const backArrow = document.getElementById("back-arrow");
    const sidebarCross = document.getElementById("sidebar-cross");

    if (sidebar) sidebar.classList.remove("d-none");
    if (msgDisplay) msgDisplay.classList.add("d-none");
    if (backArrow) backArrow.classList.add("d-none");
    if (sidebarCross) sidebarCross.classList.remove("d-none");
  }

  function hideSidebar() {
    const sidebar = document.querySelector(".sidebar");
    const msgDisplay = document.querySelector(".msg-display");
    const backArrow = document.getElementById("back-arrow");
    const sidebarCross = document.getElementById("sidebar-cross");

    if (sidebar) sidebar.classList.add("d-none");
    if (msgDisplay) msgDisplay.classList.remove("d-none");
    if (backArrow) backArrow.classList.remove("d-none");
    if (sidebarCross) sidebarCross.classList.add("d-none");
  }

  const backArrow = document.getElementById("back-arrow");
  const sidebarCross = document.getElementById("sidebar-cross");

  if (backArrow) backArrow.addEventListener("click", showSidebar);
  if (sidebarCross) sidebarCross.addEventListener("click", hideSidebar);
});
