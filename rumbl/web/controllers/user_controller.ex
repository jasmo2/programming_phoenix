defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User
  plug :authenticate_user when action in [:index , :show]

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def show(conn,  %{"username" => username}) do
    user = Repo.get_by(Rumbl.User, "username": username)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
        end
    end


end
