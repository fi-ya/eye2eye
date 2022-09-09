defmodule Eye2eyeWeb.OrderViewTest do
  use Eye2eyeWeb.ConnCase, async: true

  alias Eye2eyeWeb.OrderView

  test "convert_naive_to_date_str returns a date string" do

    assert OrderView.convert_naive_to_date_str(~N[2022-09-08 14:57:08]) == "2022-09-08"
  end

  test "format_date returns a datetime string formatted to day-month-year" do

    assert OrderView.format_date("2022-09-08") == "08-09-2022"
  end

  test "format_naive_to_date returns a date string" do
    naive_datetime =  ~N[2022-09-08 14:57:08]

    assert OrderView.format_naive_to_date(naive_datetime) == "08-09-2022"
  end
end
