(function($) {
  $(function() {
    $('td .player').jPlayer({
      swfPath: '/javascripts/audio-player',
      ready: function() {
        var player = this, playerControls = $('a.audio-control');

        player.onSoundComplete(function() {
          playerControls.filter('.active').click();
        });

        playerControls
          .click(function(e) {
            var self = $(this), src = self.attr('href');

            playerControls.removeClass('active');

            if (player.getData('diag.src') != src) {
              player.setFile(src);
              player.play();
              self.addClass('active');
            } else {
              player.setFile('');
              player.clearFile();
            }

            e.preventDefault();
          });
      }
    });
  });
})(jQuery);
