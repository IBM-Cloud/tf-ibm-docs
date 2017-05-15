(function($) {
  $(document).ready( function() {
    var sidebarOpen = true;
    var sidebar = $("#sidebar-container");
    var content = $("#content-container");
    var width = $(document). width();

    function setSidebar() {
      // 992 is the default breakpoint set in Bootstrap 3 for col-md
      if (width < 992)
        sidebarOpen = false;
      if (sidebarOpen == false) {
        sidebar.toggle();
      }
    }

    $(document).on('click', '#sidebar-tab', function() {
      $(this).toggleClass('glyphicon-chevron-right');
      $(this).toggleClass('glyphicon-chevron-left');
      sidebar.toggle(250);
      sidebarOpen = !sidebarOpen;
    });

    /* toggle category tree */
    $(document).on('click', '.tree-toggle', function () {
        $(this).children('i.fa').toggleClass('fa-caret-right');
        $(this).children('i.fa').toggleClass('fa-caret-down');
        $(this).parent().children('ul.tree').toggle(200);
    });

    function onWindowResize() {
    	setSidebar();
    }

    // initialize
    window.addEventListener('resize', onWindowResize, false);
    window.onload = function() {
      setSidebar();
    }
  });
}(jQuery));
