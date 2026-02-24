#!/usr/bin/env elixir

get_group_title = fn title -> title <> ": | disabled=true size=12" end

get_subject_type_icon = fn
  "Issue" -> "􀍷\t"
  "PullRequest" -> "󰓂\t"
  type -> type
end

get_reason_icon = fn
  "comment" -> "􀌲"
  "mention" -> "􀌮"
  "review_requested" -> "􁌶"
  "author" -> "􂄽"
  "assign" -> "􁂪"
  reason -> reason
end

replace_api_github_url = fn url ->
  url
  |> String.replace_leading("https://api.github.com/repos", "https://github.com")
  |> String.replace("/pulls/", "/pull/")
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
          |> replace_api_github_url.()

        "#{get_subject_type_icon.(subject["type"])}#{get_reason_icon.(notification["reason"])} #{title} [#{repository["name"]}] | href=#{url}"
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
        url =
          issue["html_url"]
          |> replace_api_github_url.()

        labels =
          case issue["labels"] do
            [] -> ""
            labels -> " (#{Enum.map_join(labels, ", ", & &1["name"])})"
          end

        "##{issue["number"]} #{issue["title"]} [#{issue["repository"]["name"]}] #{labels} | href=#{url}"
      end)
      |> Enum.join("\n")
    )
end
