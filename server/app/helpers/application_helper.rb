module ApplicationHelper
  def datetime_for_ui(datetime)
    return "" unless datetime
    return datetime.strftime("%Y-%m-%d %H-%M")
  end
end
