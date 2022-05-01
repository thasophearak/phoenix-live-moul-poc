defmodule MoulWeb.ProfileComponent do
  use Phoenix.Component
  import MoulWeb.PictureComponent
  import MoulWeb.SvgComponent

  def profile(assigns) do
    ~H"""
      <div class="flex justify-center">
          <%= live_redirect to: Routes.live_path(@socket, MoulWeb.HomeLive.Index) do %>
              <.picture photo={@profile["picture"]} type="profile_picture" />
          <% end %>
      </div>
      <div class="text-center pb-2 px-6">
          <%= live_redirect to: Routes.live_path(@socket, MoulWeb.HomeLive.Index), class: "inline-flex" do %>
              <h2 class="text-2xl md:text-3xl font-bold leading-normal text-neutral-900 dark:text-neutral-100"><%= @profile["name"] %></h2>
          <% end %>
          <p class="leading-normal text-neutral-700 dark:text-neutral-400 mb-2"><%= @profile["bio"] %></p>
      </div>
      <div class="flex justify-center">
          <a class="mx-2" href={"https://github.com/" <> @profile["social"]["github"]}>
              <.svg name="github" />
          </a>
          <a class="mx-2" href={"https://twitter.com/" <> @profile["social"]["twitter"]}>
              <.svg name="twitter" />
          </a>
          <a class="mx-2" href={"https://www.youtube.com/" <> @profile["social"]["youtube"]}>
              <.svg name="youtube" />
          </a>
      </div>
    """
  end
end
