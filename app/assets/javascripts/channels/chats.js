(function() {
  jQuery(document).on('turbolinks:load', function() {
    var messages, messages_to_bottom;
    messages = $('#messages');
    $('#new_message').submit(function(e) {
      var $this, textarea;
      $this = $(this);
      textarea = $this.find('#message_body');
      if ($.trim(textarea.val()).length > 1) {
        App.global_chat.send_message(textarea.val(), messages.data('chat-id'));
        textarea.val('');
      }
      e.preventDefault();
      return false;
    });
    if ($('#messages').length > 0) {
      messages_to_bottom = function() {
        return messages.scrollTop(messages.prop("scrollHeight"));
      };
      messages_to_bottom();
      $('html,body').animate({
        scrollTop: $('.chat-text-area').offset().top - 60
      }, 'slow');
      return App.global_chat = App.cable.subscriptions.create({
        channel: "ChatsChannel",
        chat_id: messages.data('chat-id')
      }, {
        connected: function() {},
        disconnected: function() {},
        received: function(data) {

          if (data['message'] == "timedout") {
            window.location.replace("/dashboard");
            return;
          }

          messages.append(data['message']);
          return messages_to_bottom();
        },
        send_message: function(message, chat_id) {
          return this.perform('send_message', {
            message: message,
            chat_id: chat_id
          });
        }
      });
    }
  });

}).call(this);
