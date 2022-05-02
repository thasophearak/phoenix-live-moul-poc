defmodule MoulWeb.StoryLive.Index do
  use MoulWeb, :live_view
  import MoulWeb.PictureComponent
  import MoulWeb.SvgComponent
  alias Phoenix.LiveView.Helpers

  @stories Application.app_dir(:moul, "priv/data/stories.json")
           |> File.read!()
           |> Jason.decode!()

  @profile Application.app_dir(:moul, "priv/data/profile.json")
           |> File.read!()
           |> Jason.decode!()

  def mount(%{"slug" => slug}, _session, socket) do
    story = Enum.find(@stories, fn s -> s["slug"] == slug end)
    title = Enum.find(story["blocks"], fn b -> b["type"] == "title" end)["text"]
    cover =  Enum.find(story["photos"], fn p -> p["type"] == "cover" end)
    default = List.first(story["photos"])

    og_image = MoulWeb.Endpoint.url() <>
      "/__moul/photos/" <> default["hash"] <> "/xl/" <> default["name"]

    if cover != nil do
      og_image = MoulWeb.Endpoint.url() <>
      "/__moul/photos/" <> cover["hash"] <> "/xl/" <> cover["name"]
    end

    {:ok,
     assign(socket,
       story: story,
       profile: @profile,
       title: title,
       page_title: title <> " | " <> @profile["name"],
       page_twitter_creator: @profile["social"]["twitter"] || "",
       page_canonical: MoulWeb.Endpoint.url() <> "/" <> story["slug"],
       page_description: @profile["bio"],
       page_og_image: og_image
     )}
  end
end
