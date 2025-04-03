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

  @valid_player %{
    ping_pong: 0,
    rock_paper_scissors: 0,
    rubik_cube: 0
  }

  @spec start_link(atom()) :: {:error, any()} | {:ok, pid()}
  def start_link(player) do
    Agent.start_link(fn ->
      %{
        player => @valid_player,
        ping_pong: %{},
        rock_paper_scissors: %{},
        rubik_cube: %{}
      }
    end)
  end

  def add(pid, player, game, score) do
    Agent.update(pid, fn state ->
      case state[player] do
        nil ->
          state = put_in(state, [player], @valid_player)
          state = put_in(state, [player, game], score)
          IO.inspect(state, label: "new")

        _ ->
          state = update_in(state, [player, game], &(&1 + score))
          IO.inspect(state, label: "exists")
      end
    end)
  end

  def get(pid, player, game) do
    Agent.get(pid, fn state ->
      state[player][game]
    end)
  end

  def new(pid, player, game) do
    Agent.update(pid, fn state ->
      recent_score = state[player][game]
      IO.inspect(recent_score, label: "recent score")
      # Update the history
      case state[game][player] do
        nil ->
          state = put_in(state, [game, player], [recent_score])
          IO.inspect(state, label: "new")
          # Set game score back to 0
          state = update_in(state, [player, game], fn _score -> 0 end)
          IO.inspect(state, label: "back to 0")

        _ ->
          state = update_in(state, [game, player], &[recent_score | &1])
          IO.inspect(state, label: "exists")
          # Set game score back to 0
          state = update_in(state, [player, game], fn _score -> 0 end)
          IO.inspect(state, label: "back to 0")
      end
    end)
  end

  def history(pid, player, game) do
    Agent.get(pid, fn state ->
      state[game][player]
    end)
  end

  def high_score(pid, player, game) do
    Agent.get(pid, fn state ->
      Enum.max(state[game][player])
    end)
  end
end
