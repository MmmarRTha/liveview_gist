defmodule ElixirGistWeb.Layouts.App do
  alias Phoenix.LiveView.JS

  def toggle_dropdown_menu do
    JS.toggle(
        to: "#dropdown_menu",
        in: {"transition ease-out duration-100", "transform opacity-0 translate-y[-10%]", "opacity-100 translate-y-0 transform"},
        out: {"transition ease-in duration-75", "transform opacity-100 translate-y-0", "opacity-0 translate-y-[-10%] transform"}
        )
  end
end
