defmodule ElixirGistWeb.UserRegistrationLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts
  alias ElixirGist.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center m-gradient">
      <h1 class="py-2 text-3xl font-bold text-white font-brand">
        Register for an account
      </h1>
      <h3 class="font-bold text-white font-brand text-l">
        Already registered?
        <.link
          navigate={~p"/users/log_in"}
          class="font-semibold text-brand hover:underline text-mLavender-dark"
        >
          Sign in
        </.link>
        to your account now.
      </h3>
    </div>
    <div class="max-w-sm mx-auto">
      <.form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <.input field={@form[:password]} type="password" placeholder="Password" required />
        <div class="py-6">
          <.button phx-disable-with="Creating account..." class="w-full create_button">
            Create an account
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
