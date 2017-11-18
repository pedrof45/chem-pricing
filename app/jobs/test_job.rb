class TestJob < ApplicationJob
  def perform(msg = nil)
    puts "Performing test job at #{Time.current}"
    puts "Msg: #{msg}"
    sleep 10
    puts "Finishing test job at #{Time.current}"
  end
end
