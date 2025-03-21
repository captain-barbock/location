defmodule Location do
  require Logger
  defdelegate country_webform_values(), to: Location.Country, as: :webform_values
  defdelegate get_country(alpha_2), to: Location.Country
  defdelegate search_country(alpha_2), to: Location.Country
  defdelegate subdivision_webform_values(alpha_2), to: Location.Subdivision, as: :webform_values
  defdelegate get_subdivision(code), to: Location.Subdivision
  defdelegate search_subdivision(code), to: Location.Subdivision
  defdelegate get_city(code), to: Location.City
  defdelegate get_city(city_name, country_code), to: Location.City

  def load_all(timeout \\ 30_000) do
    me = self()

    Logger.debug("Loading location databases...")

    [
      Task.async(fn -> Location.Country.load(me) end),
      Task.async(fn -> Location.Subdivision.load(me) end),
      Task.async(fn -> Location.City.load(me) end)
    ]
    |> Task.await_many(timeout)

    Logger.debug("Location databases loaded")
  end
end
