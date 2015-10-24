# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"

# this has been taken from the udp input, it should be DRYed

class TcpHelpers

  def pipelineless_input(plugin, size, &block)
    queue = Queue.new
    input_thread = Thread.new do
      plugin.run(queue)
    end
    block.call
    sleep 0.1 while queue.size != size
    result = size.times.inject([]) do |acc|
      acc << queue.pop
    end
    plugin.do_stop
    input_thread.join
    result
  end
end
