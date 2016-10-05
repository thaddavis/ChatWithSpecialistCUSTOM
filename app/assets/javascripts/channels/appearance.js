(function() {
  jQuery(document).on('turbolinks:load', function() {

    var buttonSelector;

    var appearances_msg_container = $('#appearances .msg_container_base');
    var appearances_current_user_container = $('#appearances .current_user');

    if ($('#appearances').length > 0) {

      $('.selectpicker').on('change', function(){
        var selected = $(this).find("option:selected").val();

        App.global_appearance.change_status(appearances_current_user_container.text(), selected);

      });

      $('.msg_container_base').on('change', function() {
        $('.msg_container_base').find('div[user_name="' + appearances_current_user_container.text() + '"]').css({ 'display': "none" });
      });

      App.global_appearance = App.cable.subscriptions.create({
          channel: "AppearanceChannel"
        }, {
          connected: function(data) {
          },
          disconnected: function() {
            window.location.replace("/dashboard");
          },
          received: function(data) {
            if (data['message'] == "timedout") {
              window.location.replace("/dashboard");
            }


            var overall = data['message'];
            var new_message = $(overall).find(".base_receive[user_name!='" + appearances_current_user_container.text() + "']").remove();

            appearances_msg_container.html('');
            appearances_msg_container.html(new_message);
          },
          change_status: function(email, status) {
            return this.perform('change_status', {
              email: email,
              status: status
            });
          }
      });

    }


  });

}).call(this);



