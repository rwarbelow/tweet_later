$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  $('.tweet_form').on('submit', function(event){
    event.preventDefault();
    var url = $(this).attr('action');
    var data = $(this).serialize();
    $.post(url, data, function(response) {
      $('.container').append('<p id="waiting">Waiting</p>');
      

      var getStatus = setInterval(function(){$.get('/status/'+ response, function(status) {
        console.log(status);
        if (status === 'true') {
          clearInterval(getStatus);
          $('#waiting').replaceWith('<p>Done</p>');
          return 'true';
        };
      })}, 1000);

    });
  });
});
