class UpdateNotifierJob < ApplicationJob
  def perform(model)
    case model
    when 'costs'
      UpdatesNotifierService.new.notify_costs
    when 'general'
      UpdatesNotifierService.new.notify_general
    when 'sysadmins'
      UpdatesNotifierService.new.notify_sysadmins
    else
      raise "Unhandled model arg #{model} for update notifier"
    end
  end
end
