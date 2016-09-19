(function() {
  jQuery(document).on('turbolinks:load', function() {

    var buttonSelector;

    appearances_msg_container = $('#appearances .msg_container_base')

    if ($('#appearances').length > 0) {

      return App.global_appearance = App.cable.subscriptions.create({
          channel: "AppearanceChannel"
        }, {
          connected: function() {
          },
          disconnected: function() {
          },
          received: function(data) {
            if (data['message'] == "timedout") {
              window.location.replace("/dashboard");
            }

            appearances_msg_container.html(data['message']);

          },
          appear: function() {
            return this.perform("appear", {
              appearing_on: $("main").data("appearing-on")
            });
          },
          away: function() {
            return this.perform("away");
          }
      });

    }


  });

}).call(this);
