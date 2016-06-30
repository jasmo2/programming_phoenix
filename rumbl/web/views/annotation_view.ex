defmodule Rumbl.AnnotationView do
  use Rumbl.Web, :view
  alias Rumbl.UserView

  def render("annotation.json", %{annotation: ann}) do
    %{
      id: ann.id,
      body: ann.body,
      at: ann.at,
      user: render_one(ann.user, UserView, "user.json")
    }
  end

end
