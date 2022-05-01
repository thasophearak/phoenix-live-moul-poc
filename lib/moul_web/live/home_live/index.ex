defmodule MoulWeb.HomeLive.Index do
  use MoulWeb, :live_view
  import MoulWeb.PictureComponent
  import MoulWeb.SvgComponent
  import MoulWeb.ProfileComponent
  alias Phoenix.LiveView.Helpers

  @stories Application.app_dir(:moul, "priv/data/stories.json")
           |> File.read!()
           |> Jason.decode!()

  @profile Application.app_dir(:moul, "priv/data/profile.json")
           |> File.read!()
           |> Jason.decode!()

  def mount(_params, _session, socket) do
    image_path =
      MoulWeb.Endpoint.url() <>
        "/__moul/photos/" <> @profile["cover"]["hash"] <> "/xl/" <> @profile["cover"]["name"]

    {:ok,
     assign(socket,
       profile: @profile,
       stories: @stories,
       page_title: @profile["name"],
       page_twitter_creator: @profile["social"]["twitter"],
       page_og_image: image_path,
       page_canonical: MoulWeb.Endpoint.url(),
       page_description: @profile["bio"]
     )}
  end
end
