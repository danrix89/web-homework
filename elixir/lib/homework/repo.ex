defmodule Homework.Repo do
  use Ecto.Repo,
    otp_app: :homework,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  def paginate(table, _latest_id, page_size, :first = _page_direction) do
    from(
      t in table,
      order_by: [{:desc, field(t, :id)}],
      limit: ^page_size
    )
    |> all()
  end

  def paginate(table, latest_id, page_size, :next = _page_direction) do
    from(
      t in table,
      where: fragment("? < ?", field(t, :id), ^latest_id),
      order_by: [{:desc, field(t, :id)}],
      limit: ^page_size
    )
    |> all()
  end

  def paginate(table, latest_id, page_size, :previous = _page_direction) do
    from(
      t in table,
      where: fragment("? > ?", field(t, :id), ^latest_id),
      order_by: [{:asc, field(t, :id)}],
      limit: ^page_size
    )
    |> all()
  end

  ##############################################################

  def get_query_directions(:first = _page_direction) do
    { "<", :desc }
  end

  def get_query_directions(:next = _page_direction) do
    { "<", :desc }
  end

  def get_query_directions(:previous = _page_direction) do
    { ">=", :asc }
  end

  ##############################################################

  def order_by_clause(query, [] = _column_comparisons, _order_direction) do
    query
  end

  def order_by_clause(query, [h | t] = _column_comparisons, order_direction) do
    { column, _ } = h
    from(
      q in query,
      order_by: [{^order_direction, ^column}]
    )
    |> order_by_clause(t, order_direction)
  end

  ##############################################################

#    def where_clause(table, _column_comparisons, _where_direction) do
#      from(
#         in table,
#          where: fragment("? > ?", field(q, :id), "937f77e0-315f-4504-86a6-68d6cd52d814"),
#          order_by: [{:asc, field(q, :id)}],
#          limit: 5
#      )
#    end

  @doc """
    Builds a Postgres row constructor comparison expression, which can be used within a where clause for multiple key-set pagination

    Arguments:
    * `operation` is a string that represents a postgres comparison function such as ">=" or "<"
    * `comparisons` is a list of tuples where the first element in the tuple is the expression that you're testing, and the second element is what you are testing against.

    # Examples:
    iex> row_constructor_comparison(">=", [{:first_name, "Dan"}, {:last_name, "Rix"}])
    "(?)"

    This function was copied/inspired by: https://elixirforum.com/t/building-an-ecto-macro-to-generate-a-row-value/19680/4
  """
  defmacro row_constructor_comparison(operation, comparisons) when is_binary(operation) and is_list(comparisons) do
    row_constructor_placeholders = Enum.map(comparisons, fn _ -> "?" end) |> Enum.join(", ")
    row_constructor_expression = "(#{row_constructor_placeholders}) #{operation} (#{row_constructor_placeholders})"
    row_constructor_arguments = comparisons |> Enum.unzip() |> Tuple.to_list() |> List.flatten()

    quote do
      fragment(unquote(row_constructor_expression), unquote_splicing(row_constructor_arguments))
    end
  end

end
