defmodule AdvancedScoreTrackerTest do
  # alias Task.Supervised
  use ExUnit.Case
  doctest AdvancedScoreTracker

  setup do
    AdvancedScoreTracker.start_link(name: __MODULE__)
    :ok
  end

  describe "Test Cases" do
    test "add/3" do
      assert :ok == AdvancedScoreTracker.add(:player1, :ping_pong, 10, __MODULE__)
    end

    test "get/2" do
      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      assert 10 == AdvancedScoreTracker.get(:player2, :ping_pong, __MODULE__)
    end

    test "get/2 with 2 players" do
      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      assert 20 == AdvancedScoreTracker.get(:player2, :ping_pong, __MODULE__)

      :ok = AdvancedScoreTracker.add(:player1, :ping_pong, 10, __MODULE__)
      assert 10 == AdvancedScoreTracker.get(:player1, :ping_pong, __MODULE__)
    end

    test "new_game/2" do
      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.add(:player1, :ping_pong, 10, __MODULE__)

      :ok = AdvancedScoreTracker.new(:player1, :ping_pong, __MODULE__)
      :ok = AdvancedScoreTracker.new(:player2, :ping_pong, __MODULE__)

      assert 0 == AdvancedScoreTracker.get(:player2, :ping_pong, __MODULE__)
      assert 0 == AdvancedScoreTracker.get(:player1, :ping_pong, __MODULE__)
    end

    test "history/2" do
      :ok = AdvancedScoreTracker.add(:player1, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.new(:player1, :ping_pong, __MODULE__)

      :ok = AdvancedScoreTracker.add(:player1, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.add(:player1, :ping_pong, 10, __MODULE__)

      :ok = AdvancedScoreTracker.new(:player1, :ping_pong, __MODULE__)
      assert [20, 10] == AdvancedScoreTracker.history(:player1, :ping_pong, __MODULE__)
    end

    test "high_score/2" do
      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.new(:player2, :ping_pong, __MODULE__)

      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.add(:player2, :ping_pong, 10, __MODULE__)
      :ok = AdvancedScoreTracker.new(:player2, :ping_pong, __MODULE__)

      assert 20 == AdvancedScoreTracker.high_score(:player2, :ping_pong, __MODULE__)
    end
  end
end
