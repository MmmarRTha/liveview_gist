defmodule ElixirGistWeb.UserForgotPasswordLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center m-gradient">
      <h1 class="py-2 text-3xl font-bold text-white font-brand">
        Forgot your password?
      </h1>
      <h3 class="font-bold text-white font-brand text-l">
        We'll send a password reset link to your inbox
      </h3>
    </div>
    <div class="max-w-sm mx-auto">
      <.form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <div class="pt-6">
          <.button phx-disable-with="Sending..." class="w-full create_button">
            Send password reset instructions
          </.button>
        </div>
      </.form>
      <p class="mt-4 font-bold text-center text-white text-l font-brand">
        <.link href={~p"/users/register"} class="text-mLavender-dark hover:underline">
          Register
        </.link>
        | <.link href={~p"/users/log_in"} class="text-mLavender-dark hover:underline">Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
