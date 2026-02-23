#!/usr/bin/env elixir

now_string =
  DateTime.utc_now()
  # Adjusting for GMT+1 timezone
  |> DateTime.shift(hour: 1)
  |> DateTime.to_iso8601()
  # Take until the hour part
  |> String.slice(0..12)
  |> (fn s -> s <> ":00" end).()

defmodule OpenMeteo do
  @lat 43.5778
  @lon 1.4399155

  def get_weather(now_string) do
    url =
      "https://api.open-meteo.com/v1/forecast?latitude=#{@lat}&longitude=#{@lon}&hourly=temperature_2m,precipitation_probability,weather_code,apparent_temperature,wind_speed_10m,precipitation&timezone=auto&forecast_days=3"

    case fetch_json(url) do
      {:ok, weather_data} ->
        {:ok, parse_weather_data(weather_data, now_string)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp fetch_json(url) do
    case System.cmd("curl", ["-s", url]) do
      {output, 0} ->
        case JSON.decode(output) do
          {:ok, %{"cod" => _, "message" => message}} ->
            {:error, message}

          {:ok, data} ->
            {:ok, data}

          {:error, decode_error} ->
            {:error, decode_error}
        end

      _ ->
        {:error, :network_error}
    end
  end

  defp parse_weather_data(data, now_string) do
    current_time_index =
      data["hourly"]["time"]
      |> Enum.find_index(&(&1 == now_string))

    end_index = current_time_index + 23

    # Take the current temperature and of the next 23 indexes
    current_time_index..end_index
    |> Enum.reduce(
      [],
      fn index, weather ->
        # Take only the time part (HH:MM)
        time = data["hourly"]["time"] |> Enum.at(index) |> String.slice(11..12)
        temperature = data["hourly"]["temperature_2m"] |> Enum.at(index) |> round()

        apparent_temperature =
          data["hourly"]["apparent_temperature"] |> Enum.at(index) |> round()

        precipitation_probability =
          data["hourly"]["precipitation_probability"] |> Enum.at(index)

        precipitation = data["hourly"]["precipitation"] |> Enum.at(index)
        wind_speed = data["hourly"]["wind_speed_10m"] |> Enum.at(index)
        weather_code = data["hourly"]["weather_code"] |> Enum.at(index)

        [
          %{
            time: time,
            temperature: temperature,
            apparent_temperature: apparent_temperature,
            precipitation_probability: precipitation_probability,
            precipitation: precipitation,
            wind_speed: wind_speed,
            weather: %{
              emoji: code_to_emoji(weather_code, time),
              description: code_to_description(weather_code)
            }
          }
          | weather
        ]
      end
    )
    |> Enum.reverse()
  end

  defp code_to_emoji(code, time_string) do
    case code do
      0 -> if time_string >= "18" or time_string <= "06", do: "􀆺", else: "􀆮"
      1 -> if time_string >= "18" or time_string <= "06", do: "􀇛", else: "􀇕"
      2 -> if time_string >= "18" or time_string <= "06", do: "􀇛", else: "􀇕"
      3 -> "􀇃"
      45 -> "􀇋"
      48 -> "􀇋"
      51 -> "􀇅"
      53 -> "􀇅"
      55 -> "􀇅"
      56 -> "􀇏"
      57 -> "􀇏"
      61 -> "􀇇"
      63 -> "􀇇"
      65 -> "􀇇"
      66 -> "􀇏"
      67 -> "􀇏"
      71 -> "􀇥"
      73 -> "􀇥"
      75 -> "􀇥"
      77 -> "􀇥"
      80 -> "􀇇"
      81 -> "􀇇"
      82 -> "􀇇"
      85 -> "􀇥"
      86 -> "􀇥"
      95 -> "􀇟"
      96 -> "􀇟"
      99 -> "􀇟"
      _ -> "􀅍"
    end
  end

  defp code_to_description(code) do
    case code do
      0 -> "Clear sky"
      1 -> "Mainly clear"
      2 -> "Partly cloudy"
      3 -> "Overcast"
      45 -> "Fog"
      48 -> "Depositing rime fog"
      51 -> "Light drizzle"
      53 -> "Moderate drizzle"
      55 -> "Dense drizzle"
      56 -> "Light freezing drizzle"
      57 -> "Dense freezing drizzle"
      61 -> "Slight rain"
      63 -> "Moderate rain"
      65 -> "Heavy rain"
      66 -> "Light freezing rain"
      67 -> "Heavy freezing rain"
      71 -> "Slight snow fall"
      73 -> "Moderate snow fall"
      75 -> "Heavy snow fall"
      77 -> "Snow grains"
      80 -> "Slight rain showers"
      81 -> "Moderate rain showers"
      82 -> "Violent rain showers"
      85 -> "Slight snow showers"
      86 -> "Heavy snow showers"
      95 -> "Slight or moderate thunderstorm"
      96 -> "Thunderstorm with slight hail"
      99 -> "Thunderstorm with heavy hail"
      _ -> "Unknown weather condition"
    end
  end

  def render(now_string) do
    case get_weather(now_string) do
      {:error, error} ->
        "􀇿 Error\n---\n#{error}"

      {:ok, weather_data} ->
        [current | forecast] = weather_data

        """
        #{current.weather.emoji}#{current.temperature}°C (#{current.apparent_temperature}°C) | shortcut=ctrl+option+w
        ---
        #{current.weather.emoji}#{current.weather.description} | disabled=true
        􀇅#{current.precipitation_probability}% 􁹡#{current.precipitation} mm | disabled=true
        􀇤#{current.wind_speed} km/h | disabled=true
        ---
        #{Enum.map_join(forecast, "\n", fn forecast ->
          rain = if forecast.precipitation_probability > 0, do: " 􀇅#{forecast.precipitation_probability}% 􁹡#{forecast.precipitation} mm", else: ""
          """
          #{forecast.time}h:\t#{forecast.weather.emoji}#{forecast.temperature}°C (#{forecast.apparent_temperature}°C)#{rain} | disabled=true
          """
        end)}
        """
    end
  end
end

IO.puts(OpenMeteo.render(now_string))
