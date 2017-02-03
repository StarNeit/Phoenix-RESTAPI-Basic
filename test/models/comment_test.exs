defmodule Playdays.CommentTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Comment

  test "changeset with valid attributes", %{} do
    valid_attrs = %{
      member_id: 1,
      event_id: 1,
      text_content: "This is a testing."
    }
    changeset = Comment.changeset(%Comment{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes", %{} do
    invalid_attrs = %{
      consumer_id: 1,
      event_id: 1
    }
    changeset = Comment.changeset(%Comment{}, invalid_attrs)
    refute changeset.valid?
  end
end
