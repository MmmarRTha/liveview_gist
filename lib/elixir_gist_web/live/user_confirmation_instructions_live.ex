defmodule ElixirGistWeb.UserConfirmationInstructionsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center m-gradient">
      <h1 class="py-2 text-3xl font-bold text-white font-brand">
        No confirmation instructions received?
        <h3 class="font-bold text-white font-brand text-l">
          We'll send a new confirmation link to your inbox
        </h3>
      </h1>
    </div>

      <div class="max-w-sm mx-auto">
      <.form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <div class="pt-6">
          <.button phx-disable-with="Sending..." class="w-full create_button">
            Resend confirmation instructions
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

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
