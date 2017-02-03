  defmodule Playdays.Api.V1.Admin.TagControllerTest do
  use Playdays.ConnCase, async: false

  import Playdays.Utils.MapUtils


  setup do
    admin = create(:admin)
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-auth-token", admin.authentication_token)

    tags = create_list(3, :tag)
    tag = hd tags
    {:ok, conn: conn, tags: tags, tag: tag}
  end


  test "list all tags", %{conn: conn} do
    conn = get conn, api_v1_admin_tag_path(conn, :index)

    tags = conn.assigns.tags

    expected_data = Enum.map(tags, fn(tag) ->
                      %{
                        id: tag.id,
                        title: tag.title
                      }
                    end)

    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "show a tag", %{conn: conn, tag: tag} do
    conn = get(conn, api_v1_admin_tag_path(conn, :show, tag))

    expected_data = %{
                      id: tag.id,
                      title: tag.title
                    }
    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

end
