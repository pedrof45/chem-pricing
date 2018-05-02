class UpdatesNotifierService < PowerTypes::Service.new

  NOTIFY_COSTS_CLASSES = [Cost]

  def notify_costs
    notify :costs
  end

  NOTIFY_GENERAL_CLASSES = [NormalBulkFreight, ChoppedBulkFreight, ProductBulkFreight, EspecialPackedFreight, NormalPackedFreight]

  def notify_general
    notify :general
  end

  NOTIFY_SYSADMINS_CLASSES = ApplicationRecord.descendants

  def notify_sysadmins
    notify :sysadmins
  end

  def notify(type)
    objs = fetch_objects(type)
    recipients = recipients_for_type(type)
    unless objs.empty? || recipients.empty?
      NotificationMailer.send_with_sendgrid(type.to_s, objs, recipients.to_a).deliver_now
    end
    last_notification_time(type).update(value: Time.current.to_i)
  end

  private

  def fetch_objects(type)
    classes = Object.const_get "UpdatesNotifierService::NOTIFY_#{type.upcase}_CLASSES"
    objects = []
    lnt = Time.at(last_notification_time(type).value)
    classes.each do |klass|
      objects += klass.where('updated_at > ?', lnt).to_a
    end
    objects
  end

  def recipients_for_type(type)
    # TESTING PHASE, ONLY 2 SYSADMINS
    return User.where(id: [2, 22])
    case type.to_s
    when 'costs'
      User.all
    when 'general'
      User.all
    when 'sysadmins'
      User.where(role: :sysadmin)
    else
      raise "Unhandled notification type #{type}"
    end
  end

  def last_notification_time(type)
    SystemVariable.find_by!(name: "last_#{type}_notification_timestamp")
  end
end