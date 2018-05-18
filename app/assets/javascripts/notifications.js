var notifications = (function() {
  function notifications() {
    this.notifications = $("[data-behavior='notifications']");
    if (this.notifications.length > 0) {
      this.handleSuccess(this.notifications.data("notifications"));
      $("[data-behavior='notifications-link']").on("click", this.handleClick);
      setInterval(((function(_this) {
        return function() {
          return _this.getNewNotifications();
        };
      })(this)), 5000);
    }
  }

  notifications.prototype.getNewNotifications = function() {
    return $.ajax({
      url: "/api/v1/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: this.handleSuccess
    });
  };

  notifications.prototype.handleClick = function(e) {
    return $.ajax({
      url: "/api/v1/notifications/mark_as_read",
      dataType: "JSON",
      method: "POST",
      success: function() {
        return $("[data-behavior='unread-count']").text(0);
      }
    });
  };

  notifications.prototype.handleSuccess = function(data) {
    var items, unread_count;
    items = $.map(data, function(notification) {
      return notification.template;
    });
    unread_count = 0;
    $.each(data, function(i, notification) {
      if (notification.unread) {
        return unread_count += 1;
      }
    });
    $("[data-behavior='unread-count']").text(unread_count);
    return $("[data-behavior='notification-items']").html(items);
  };

  return notifications;

})();

jQuery(function() {
  return new notifications;
});
