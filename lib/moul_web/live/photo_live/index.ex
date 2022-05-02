defmodule MoulWeb.PhotoLive.Index do
  use MoulWeb, :live_view
  import MoulWeb.PictureComponent
  alias Phoenix.LiveView.Helpers
  alias Phoenix.LiveView.JS
  alias MoulWeb.Router.Helpers, as: Routes

  @stories Application.app_dir(:moul, "priv/data/stories.json")
           |> File.read!()
           |> Jason.decode!()

  @profile Application.app_dir(:moul, "priv/data/profile.json")
           |> File.read!()
           |> Jason.decode!()

  def mount(%{"slug" => slug, "pid" => pid}, _session, socket) do
    story = Enum.find(@stories, fn s -> s["slug"] == slug end)
    active = Enum.find_index(story["photos"], fn p -> p["hash"] == pid end)
    photo = Enum.at(story["photos"], active)
    total_count = Enum.count(story["photos"])
    prev = Enum.at(story["photos"], active - 1)
    next = Enum.at(story["photos"], active + 1)
    {_, photos} = Jason.encode(story["photos"])
    og_image = MoulWeb.Endpoint.url() <>
        "/__moul/photos/" <> photo["hash"] <> "/xl/" <> photo["name"]

    {:ok,
     assign(socket,
       story: story,
       profile: @profile,
       active: active,
       prev: prev["hash"],
       next: next["hash"],
       total_count: total_count,
       photos: photos,
       page_title:
         Enum.find(story["blocks"], fn b -> b["type"] == "title" end)["text"] <>
           " | " <> @profile["name"],
       page_twitter_creator: @profile["social"]["twitter"] || "",
       page_canonical:
         MoulWeb.Endpoint.url() <> "/" <> story["slug"] <> "/photo/" <> photo["hash"],
       page_description: @profile["bio"],
       page_og_image: og_image
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  defp apply_action(socket, :show, %{"slug" => slug, "pid" => pid}) do
    story = Enum.find(@stories, fn s -> s["slug"] == slug end)
    active = Enum.find_index(story["photos"], fn p -> p["hash"] == pid end)
    total_count = Enum.count(story["photos"])
    prev = Enum.at(story["photos"], active - 1)
    next = Enum.at(story["photos"], active + 1)

    socket
    |> assign(prev: prev["hash"], next: next["hash"], active: active, total_count: total_count)
  end
end
