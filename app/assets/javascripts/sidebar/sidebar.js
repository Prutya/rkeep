(function() {
    var sidebarDisplayWidth = "20%";
    var sidebarHideWidth = "0";

    if (window.innerWidth < 600) {
        sidebarDisplayWidth = "80%";
    }

    var sidebar = document.getElementById('sidebar');
    var content = document.getElementById('content');
    var contentWrapper = document.getElementById('content-wrapper');
    var sidebarToggle = document.getElementById('sidebar-toggle');
    var sidebarIsOpened = false;

    function openSidebar() {
        sidebar.style.width = sidebarDisplayWidth;
        contentWrapper.style.marginLeft = sidebarDisplayWidth;
        sidebarIsOpened = true;
    }

    function closeSidebar() {
        sidebar.style.width = sidebarHideWidth;
        contentWrapper.style.marginLeft = sidebarHideWidth;
        sidebarIsOpened = false;
    }

    function toggleSidebar() {
        if (sidebarIsOpened) {
            closeSidebar();
        } else {
            openSidebar();
        }
    }

    if (content != null && sidebarToggle != null) {
        content.addEventListener('click', closeSidebar);
        sidebarToggle.addEventListener('click', toggleSidebar);
    }
})();
