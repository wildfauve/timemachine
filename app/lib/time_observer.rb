class TimeObserver

  def add_time_successful(result)
    # push_metric(result)
    # update_state
  end

  def update_state
    ScoreCard::Client.new.enqueue(ScoreCard::MetricBuilder.state_transition do |state|
      state.metric_name = "timeline_test_state"
      state.new_state = "initiated"
    end).send_metrics
  end

  def push_metric(result)
    ScoreCard::Client.new.enqueue(ScoreCard::MetricBuilder.counter do |counter|
      counter.metric_name = metric_name(result)
      counter.data_type = :float
      counter.inc(result[:entry].diff)
    end).send_metrics
  end

  def metric_name(result)
    e = result[:entry]
    day = result[:day]
    "#{e.assigned_project.customer.name}-#{day.date.year}-#{day.date.month}"
  end


end
