json.array! @notifications do |notification|
  json.id notification.id
  json.unread !notification.read_at?
  json.template render partial: "notifications/index", locals: {notification: notification}, formats: [:html]
end
