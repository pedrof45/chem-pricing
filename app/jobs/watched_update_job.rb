class WatchedUpdateJob < ApplicationJob
  def perform(obj_type, obj_id)
    service = WatchedUpdateService.new
    case obj_type.to_s
    when 'cost'
      service.run_for_cost(Cost.find(obj_id))
    when 'upload'
      service.run_for_upload(Upload.find(obj_id))
    end
  end
end
