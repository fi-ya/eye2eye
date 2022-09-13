defmodule Eye2eyeWeb.OrderView do
  use Eye2eyeWeb, :view

  def convert_naive_to_date_str(naive_date_time) do
    naive_date_time
    |> NaiveDateTime.to_date()
    |> Date.to_string()
  end

  def format_date(date_str) do
    date_list = String.split(date_str, "-")

    formatted_date =
      Enum.at(date_list, 2) <> "-" <> Enum.at(date_list, 1) <> "-" <> Enum.at(date_list, 0)

    formatted_date
  end

  def format_naive_to_date(naive_date_time) do
    date =
      naive_date_time
      |> convert_naive_to_date_str()
      |> format_date()

    date
  end
end
