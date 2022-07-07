/*!
    * Start Bootstrap - SB Admin v7.0.5 (https://startbootstrap.com/template/sb-admin)
    * Copyright 2013-2022 Start Bootstrap
    * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-sb-admin/blob/master/LICENSE)
    */
    // 
// Scripts
// 

window.addEventListener('DOMContentLoaded', event => {
          

    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        // Uncomment Below to persist sidebar toggle between refreshes
        if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
           document.getElementById("layoutSidenav_nav").style.transition = "transform 0s ease-in-out";
           document.getElementById("layoutSidenav_nav").style.transition = "margin 0s ease-in-out";
           document.getElementById("layoutSidenav_content").style.transition = "transform 0s ease-in-out";
           document.getElementById("layoutSidenav_content").style.transition = "margin 0s ease-in-out";
     
           document.body.classList.toggle('sb-sidenav-toggled');
        }
        sidebarToggle.addEventListener('click', event => {
           document.getElementById("layoutSidenav_nav").style.transition = "transform 1s ease-in-out";
           document.getElementById("layoutSidenav_nav").style.transition = "margin 1s ease-in-out";
           document.getElementById("layoutSidenav_content").style.transition = "transform 1s ease-in-out";
           document.getElementById("layoutSidenav_content").style.transition = "margin 1s ease-in-out";
     
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }

});

