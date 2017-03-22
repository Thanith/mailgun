defmodule Mailgun.Email do
  @type t :: %__MODULE__{
    subject: nil | String.t,
    from: nil | String.t,
    to: nil | String.t,
    cc: nil | [String.t],
    html: nil | String.t,
    text: nil | String.t,
    attachments: nil | [Map.t]
  }

  @list_string_attribute_pipe_functions ~w(cc)a
  @list_map_attribute_pipe_functions ~w(attachments)a
  @attribute_pipe_functions ~w(from to subject html text)a

  defstruct from: nil,
      to: nil,
      cc: nil,
      subject: nil,
      html: nil,
      text: nil,
      attachments: nil

  alias Booking.Mail.Email

  @spec new_email(Enum.t) :: __MODULE__.t
  def new_email(attrs \\ []) do
    struct!(%__MODULE__{}, attrs)
  end

  for function_name <- @list_map_attribute_pipe_functions do
    @spec unquote(function_name)(__MODULE__.t, [Map.t]) :: __MODULE__.t
    def unquote(function_name)(email, attr) do
      Map.put(email, unquote(function_name), attr)
    end
  end

  for function_name <- @list_string_attribute_pipe_functions do
    @spec unquote(function_name)(__MODULE__.t, [String.t]) :: __MODULE__.t
    def unquote(function_name)(email, attr) do
      case attr do
        nil -> Map.put(email, unquote(function_name), attr)
        _ -> Map.put(email, unquote(function_name), Enum.join(attr, ","))
      end
    end
  end

  for function_name <- @attribute_pipe_functions do
    def unquote(function_name)(email, attr) do
      Map.put(email, unquote(function_name), attr)
    end
  end

  def to_map(email) do
    email
    |> Map.from_struct()
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
  end
end