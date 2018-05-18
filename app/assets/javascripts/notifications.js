var Notifications,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Notifications = (function() {
  function Notifications() {
    this.handleSuccess = bind(this.handleSuccess, this);
    this.handleClick = bind(this.handleClick, this);
    this.notifications = $("[data-behavior='notifications']");
    if (this.notifications.length > 0) {
      this.setup();
    }
  }

  Notifications.prototype.setup = function() {
    $("[data-behavior='notifications-link']").on("click", this.handleClick);
    return $.ajax({
      url: "/api/v1/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: this.handleSuccess
    });
  };

  Notifications.prototype.handleClick = function(e) {
    return $.ajax({
      url: "api/v1/notifications/mark_as_read",
      method: "POST",
      dataType: "JSON",
      success: function() {
        return $("[data-behavior='unread-count']").text(0);
      }
    });
  };

  Notifications.prototype.handleSuccess = function(data) {
    var items;
    items = $.map(data, function(notification) {
      return "<a class='dropdown-item' href='" + notification.url + "'>" + notification.actor + " " + notification.action + " " + notification.notifiable.type + "</a>";
    });
    $("[data-behavior='unread-count']").text(items.length);
    return $("[data-behavior='notification-items']").html(items);
  };

  return Notifications;

})();

jQuery(function() {
  return new Notifications;
});
