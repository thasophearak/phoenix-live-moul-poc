defmodule MoulWeb.PictureComponent do
  use Phoenix.Component

  def picture(assigns) do
    ~H"""
      <picture class={picture_classes(@type)} data-size={to_string(@photo["width"])<>":"<> to_string(@photo["height"])}>
        <img
            class={img_classes(@type)}
            src={"data:image/jpeg;charset=utf-8;base64,"<>@photo["bh"]}
            data-srcset={src_set(@photo)}
            data-sizes="auto"
            alt={@photo["name"]}
          />
      </picture>
    """
  end

  defp picture_classes(type) do
    case type do
      "profile_picture" ->
        "w-28 h-28 md:w-36 md:h-36 rounded-full"

      "profile_cover" ->
        "absolute top-0 left-0 w-full h-full"

      "story_cover" ->
        "absolute top-0 left-0 w-full h-full rounded-2xl transition duration-[4s] ease-in group-hover:scale-150"

      "grid" ->
        "moul-grid"
    end
  end

  defp img_classes(type) do
    case type do
      "profile_picture" ->
        "lazy w-28 h-28 md:w-36 md:h-36 rounded-full"

      "profile_cover" ->
        "lazy w-full h-full object-cover"

      "story_cover" ->
        "lazy w-full h-full object-cover rounded-2xl"

      "grid" ->
        "lazy"
    end
  end

  def src_set(photo) do
    prefix = "/__moul/photos/"
    ~s(#{prefix}#{photo["hash"]}/sm/#{photo["name"]} 320w,
#{prefix}#{photo["hash"]}/md/#{photo["name"]} 768w,
#{prefix}#{photo["hash"]}/lg/#{photo["name"]} 1024w,
#{prefix}#{photo["hash"]}/xl/#{photo["name"]} 1440w
    )
  end
end
