defmodule AdvancedScoreTracker do
  @moduledoc """
  This is a Agent supervised program that will:
    Start a new instance of a user.
    Open up a new game.
    Check the history of a game.
    Find the high score of a game.

    I will need to add an other program that will keep track of everything.
    I want to be able to store the needed values in a text file on the computer
  """

  use Agent

  @name __MODULE__
  @valid_player %{
    ping_pong: 0,
    rock_paper_scissors: 0,
    rubik_cube: 0
  }

  @spec start_link(atom()) :: {:error, any()} | {:ok, pid()}
  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)

    Agent.start_link(
      fn ->
        %{
          ping_pong: %{},
          rock_paper_scissors: %{},
          rubik_cube: %{}
        }
      end,
      opts
    )
  end

  def add(player, game, score, name \\ @name) do
    Agent.update(name, fn state ->
      case state[player] do
        nil ->
          put_in(state, [player], @valid_player)
          |> put_in([player, game], score)

        _ ->
          update_in(state, [player, game], &(&1 + score))
      end
    end)
  end

  def get(player, game, name \\ @name) do
    Agent.get(name, fn state ->
      state[player][game]
    end)
  end

  def new(player, game, name \\ @name) do
    Agent.update(name, fn state ->
      recent_score = state[player][game]
      # Update the history
      case state[game][player] do
        nil ->
          put_in(state, [game, player], [recent_score])
          # Set game score back to 0
          |> update_in([player, game], fn _score -> 0 end)

        _ ->
          update_in(state, [game, player], &[recent_score | &1])
          # Set game score back to 0
          |> update_in([player, game], fn _score -> 0 end)
      end
    end)
  end

  def history(player, game, name \\ @name) do
    Agent.get(name, fn state ->
      state[game][player]
    end)
  end

  def high_score(player, game, name \\ @name) do
    Agent.get(name, fn state ->
      Enum.max(state[game][player])
    end)
  end
end
