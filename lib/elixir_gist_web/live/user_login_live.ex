defmodule ElixirGistWeb.UserLoginLive do
  use ElixirGistWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center m-gradient">
      <h1 class="py-2 text-3xl font-bold text-white font-brand">
        Sign in to account
      </h1>
      <h3 class="font-bold text-white font-brand text-l">
        Don't have an account?
        <.link
          navigate={~p"/users/register"}
          class="font-semibold text-brand hover:underline text-mLavender-dark"
        >
          Sign up
        </.link>
        for an account now.
      </h3>
    </div>
    <div class="max-w-sm mx-auto">
      <.form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <.input field={@form[:password]} type="password" placeholder="Password" required />
        <div class="flex justify-between py-4 item-scenter">
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link
            href={~p"/users/reset_password"}
            class="font-semibold text-m text_brand text-mDark-light hover:underline"
          >
            Forgot your password?
          </.link>
        </div>
        <.button phx-disable-with="Signing in..." class="w-full create_button">
          Sign in <span aria-hidden="true">→</span>
        </.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
