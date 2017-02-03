defmodule Playdays.Api.V1.Consumer.LoginController do
	use Playdays.Web, :controller
	alias Playdays.Member
	alias Playdays.Login
	alias Playdays.Services.Consumer.Consumer.RegisterConsumer

	import Playdays.Utils.MapUtils
	#import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

	def login(conn, user_params) do

		member = Repo.get_by(Member, email: user_params["email"])
		cond do
			#member && checkpw(user_params["password"], member.password_hash) ->
			member && (user_params["password"] == member.password_hash) ->
				#token = Member.generate_token(member)
				token=Login.registration_changeset(%Login{}, %{member_id: member.id})
				{:ok, login} = Repo.insert(token)
				
				#device_uuid = conn |> get_req_header("x-device-uuid") |> List.first
			    #fb_user_id = conn |> get_req_header("x-fb-user-id") |> List.first
			    #fb_user_id = member_id
			    #fb_access_token = conn |> get_req_header("x-fb-access-token") |> List.first
			    #fb_access_token=token
			    #c_params = Map.merge(conn.params , %{
			    #              device_uuid: device_uuid,
			    #              fb_user_id: fb_user_id,
			    #              fb_access_token: fb_access_token
			    #            })
			    #          |> to_atom_keys
			    #case RegisterConsumer.call(c_params) do
			    #  {:error, changeset} ->
			    #    conn
			    #    |> put_status(:unprocessable_entity)
			    #    |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
			    #    |> halt
			    #  {:ok, consumer} ->
			    #    conn |> assign(:current_consumer, preload_for_render(consumer))
			    #end

				params=%{token: login.token, fname: member.fname, lname: member.lname, about_me: member.about_me, id: member.id, email: member.email, region_id: member.region_id, district_id: member.district_id, languages: member.languages, children: member.children, mobile_phone_number: member.mobile_phone_number, password: user_params["password"], like_events: member.like_events, like_places: member.like_places}
				conn
			    |> put_status(:created)
			    |> put_resp_header("location", api_v1_consumer_login_path(conn, :show, member))
			    |> render("show.json", login: params)
			member ->
				conn
		        |> put_status(:unauthorized)
		        |> render("error.json", message: "Nope")
		    true ->
        		#dummy_checkpw
        		conn
        		|> put_status(:unauthorized)
        		|> render("error.json", message: "Nope")
		end		


	    #if member = Repo.get_by(Member, email: user_params["email"]) do

	    #  token = Member.generate_token(member)

	    #  conn
	    #  |> put_status(200)
	    #  |> render("session.json", %{token: token, member: member})
	    #else
	    #  conn
	    #  |> put_status(:unprocessable_entity)
	    #  |> render("error.json", message: "Nope")
	    #end
	end

	def show(conn, %{"id" => id}) do
	    member = Repo.get!(Member, id)
	    render(conn, "show.json", member: member)
	  end

	def logout(conn, params) do
		cond do
			true ->
	    		conn
	    		|> put_resp_header("location", "/api/")
	    		|> render("logout.json", message: "Logout")
	    end
	end

	defp preload_for_render(consumer) do
	    consumer
	    |> Repo.preload([:region, :district])
	  end

end