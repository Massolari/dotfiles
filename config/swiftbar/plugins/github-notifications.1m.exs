#!/usr/bin/env elixir

get_group_title = fn title -> title <> ": | disabled=true size=12" end

get_subject_type_icon = fn
  "Issue" -> ""
  "PullRequest" -> "󰓂"
  type -> type
end

notifications =
  case System.shell("gh api notifications") do
    {notifications_json, 0} ->
      {:ok, notifications} = JSON.decode(notifications_json)
      notifications

    {error, code} ->
      IO.puts("Failed to fetch notifications")
      IO.puts("---")
      IO.puts("Error: #{error} (code: #{code})")
      System.halt(1)
  end

issues =
  case System.shell("gh api issues") do
    {issues_json, 0} ->
      {:ok, issues} = JSON.decode(issues_json)
      issues

    {error, code} ->
      IO.puts("Failed to fetch issues")
      IO.puts("---")
      IO.puts("Error: #{error} (code: #{code})")
      System.halt(1)
  end

IO.puts(
  " #{length(notifications)}  #{length(issues)} | font=JetBrainsMonoNF-Regular size=14 shortcut=ctrl+option+g"
)

if not Enum.empty?(notifications) or not Enum.empty?(issues) do
  IO.puts("---")
end

case notifications do
  [] ->
    nil

  _ ->
    IO.puts(get_group_title.("Notifications"))
    IO.puts("Open in GitHub | href=https://github.com/notifications")

    IO.puts(
      notifications
      |> Enum.map(fn notification ->
        subject = notification["subject"]
        repository = notification["repository"]

        title =
          subject["title"]
          |> String.replace("|", "⎹ ")

        url =
          subject["url"]
          |> String.replace_leading("https://api.github.com/repos", "https://github.com")
          |> String.replace("/pulls/", "/pull/")

        "#{get_subject_type_icon.(subject["type"])} #{title} - #{repository["name"]}| href=#{url}"
      end)
      |> Enum.join("\n")
    )
end

case issues do
  [] ->
    nil

  _ ->
    IO.puts(get_group_title.("Issues"))

    IO.puts(
      issues
      |> Enum.map(fn issue ->
        "#{issue["title"]} | href=#{issue["url"]}"
      end)
      |> Enum.join("\n")
    )
end
