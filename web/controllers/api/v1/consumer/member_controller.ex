defmodule Playdays.Api.V1.Consumer.MemberController do
  use Playdays.Web, :controller

  alias Playdays.Member
  alias Playdays.Login

  plug :scrub_params, "email" when action in [:create, :update]

  def index(conn, _params) do
    members = Repo.all(Member)
    render(conn, "index.json", members: members)
  end

  def create(conn, member_params) do
    changeset = Member.changeset(%Member{}, member_params)

    case Repo.insert(changeset) do
      {:ok, member} ->
        token=Login.registration_changeset(%Login{}, %{member_id: member.id})
        {:ok, login} = Repo.insert(token)
        params=%{token: login.token, fname: member.fname, lname: member.lname, about_me: member.about_me, id: member.id, email: member.email, region_id: member.region_id, district_id: member.district_id, languages: member.languages, children: member.children, mobile_phone_number: member.mobile_phone_number, password: member_params["password"]}
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_consumer_member_path(conn, :show, member))
        |> render("show.json", member: params)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = Repo.get!(Member, id)
    render(conn, "show.json", member: member)
  end

  def update(conn,  member_params) do
    token=member_params["token"]
    member = Repo.get_by(Member, email: member_params["email"])
    changeset = Member.changeset(member, member_params)

    case Repo.update(changeset) do
      {:ok, member} ->
        params=%{token: token, fname: member.fname, lname: member.lname, about_me: member.about_me, id: member.id, email: member.email, region_id: member.region_id, district_id: member.district_id, languages: member.languages, children: member.children, mobile_phone_number: member.mobile_phone_number, password: member_params["password"], like_events: member.like_events, like_places: member.like_places}
        conn
        |> render("show.json", member: params)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Repo.get!(Member, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member)

    send_resp(conn, :no_content, "")
  end
end
