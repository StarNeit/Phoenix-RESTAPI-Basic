defmodule Playdays.Comment do
  use Playdays.Web, :model

  schema "comments" do
    belongs_to :member,  Playdays.Member

    belongs_to :trial_class,  Playdays.TrialClass
    belongs_to :event,  Playdays.Event
    belongs_to :place,  Playdays.Place

    field :text_content, :string

    timestamps
  end

  @required_fields [:member_id, :text_content]
  @whitelist_fields @required_fields ++ [:trial_class_id, :event_id, :place_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
  end
end
