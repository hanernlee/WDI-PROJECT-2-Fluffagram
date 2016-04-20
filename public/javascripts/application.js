$(document).ready(function(){
     $('.parallax').parallax();
     $("#login").hide();

     $(".button-collapse").sideNav();

       // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
      $('.modal-trigger').leanModal();

      $("#log").click(function(){
        $("#sign_up").hide(1000);
        $("#login").show(1000);
      });

      $("#sign").click(function(){
        $("#login").hide(1000);
        $("#sign_up").show(1000);
      });

      $( document ).on( 'focus', ':input', function(){
      $( this ).attr( 'autocomplete', 'off' );
      });

      // scroll to mid_content div
      $("#arrow").on('click', function(e) {
          e.preventDefault();
          $('html, body').animate({
              scrollTop: $("#mid_content").offset().top - $(this).height()
          }, 600);
      });

      // Hide navbar on on scroll down
      var senseSpeed = 5;
      var previousScroll = 0;
      $(window).scroll(function(event){
         var scroller = $(this).scrollTop();
         if (scroller-senseSpeed > previousScroll){
            $("#nav_bar").filter(':not(:animated)').slideUp();
         } else if (scroller+senseSpeed < previousScroll) {
            $("#nav_bar").filter(':not(:animated)').slideDown();
         }
         previousScroll = scroller;
       });

       $("#comment_btn").click(function(){
         $("#comments").toggle(1000);
       });

});
