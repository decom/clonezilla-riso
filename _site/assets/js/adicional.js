
function configuraMenuManual(){
  if ($(window).width() <= 960) {
    $("LINK[href='assets/css/jquery.mmenu.widescreen.css']").remove();
    $("#navManual").mmenu({ extensions: ["theme-dark","border-none","pagedim-black"],
         "offCanvas": {
            "position": "right",
            "zposition" : "front"
         }
         
      });
    $("#tdMenu").removeClass("LarguraMenuManual");
    }
    else {
      $('head').append($('<link rel="stylesheet" type="text/css" />').attr('href', 'assets/css/jquery.mmenu.widescreen.css'));
      $("#navManual").mmenu({ extensions: ["widescreen","theme-dark","border-none"],
         "offCanvas": {
            "position": "right",
            "zposition": "next"
         }
         
      });
      $("#tdMenu").addClass("LarguraMenuManual");      
    }
}

function configuraFooter(){
  if ($("#navManual").is(':visible')) {
      $("#footer").addClass("LarguraFooter");
  }  
  else {
      $("#footer").removeClass("LarguraFooter");
  } 
    $("#geral").css("min-height", $( window ).height()-139);
  }

function configuraPosts(){
  var array = [];
   $( ".postes" ).each(function( index ) {
     array.push( $( this ).height() );
  });
     
   $('.postes').css('height', Math.max.apply(null, array )+20);

  }  

jQuery(document).ready(function( $ ) {
  
  configuraMenuManual();
  configuraFooter();
  configuraPosts();

  $(window).resize(function(){
    configuraMenuManual();
    configuraFooter();
    configuraPosts();
  });   
   var $nn = $('#selectMenuManual').val();

  $($nn).addClass('activeManual');
});







