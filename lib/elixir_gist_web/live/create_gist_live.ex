defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view
  alias ElixirGistWeb.GistFormComponent
  alias ElixirGist.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center m-gradient">
      <h1 class="text-3xl font-bold text-white font-brand">
        Instantly share Elixir code, notes and snippets.
      </h1>
    </div>

    <.live_component
      module={GistFormComponent}
      id={:new}
      form={to_form(Gists.change_gist(%Gist{}))}
      current_user={@current_user}
    />
    """
  end
end
