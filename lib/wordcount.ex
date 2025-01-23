defmodule Wordcount do
  @moduledoc """
  Utilities for wordcount.
  """

  @doc """
    Count tokens of length `kmer_length` in sequuence.

    ## Examples

      iex> Wordcount.count("MFRRLTRR", 2)
      %{"MF" => 1, "LT" => 1, "RR" => 2}

      iex> Wordcount.count("MFRRLTRRMF", 2)
      %{"MF" => 2, "LT" => 1, "RR" => 2}

      iex> Wordcount.count("MFRRLTMFR", 3)
      %{"MFR" => 2, "RLT" => 1}
  """
  @spec count(String.t(), pos_integer()) :: map()
  def count(sequence, kmer_length) do
    sequence
    |> String.graphemes()
    |> Enum.chunk_every(kmer_length, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.reduce(%{}, fn word, acc ->
      Map.update(acc, word, 1, &(&1 + 1))
    end)
  end

  @spec frequency(String.t(), pos_integer()) :: map()
  def frequency(sequence, kmer_length) do
    sequence
    |> String.graphemes()
    |> Enum.chunk_every(kmer_length, 1, :discard) # sliding window
    |> Enum.map(&Enum.join/1)
    |> Enum.reduce(%{}, fn word, acc ->
      Map.update(acc, word, 1, &(&1 + 1))
    end)
  end

  @spec coverage(String.t(), pos_integer()) :: map()
  def coverage(sequence, kmer_length) do
    sequence
    |> String.graphemes()
    |> Enum.chunk_every(kmer_length, 1, :discard) # sliding window
    |> Enum.map(&Enum.join/1)
    |> Enum.uniq()
    |> Enum.map(fn word -> {word, 1} end)
    |> Map.new()
  end

  @doc """
    Count tokens of length `kmer_length` in list of sequuences.

    ## Examples

      iex> Wordcount.wordcount(["MFRRLTRR", "RRAABB"], 2)
      %{"MF" => 1, "LT" => 1, "RR" => 3, "AA" => 1, "BB" => 1}
  """
  @spec wordcount([String.t()], pos_integer(), atom()) :: map()
  def wordcount(sequences, kmer_length, task) do
    sequences
    |> Enum.map(&String.trim(&1))
    |> Task.async_stream(
      fn batch ->
        case task do
          :coverage -> Wordcount.coverage(batch, kmer_length)
          :frequency -> Wordcount.frequency(batch, kmer_length)
          _ -> Wordcount.frequency(batch, kmer_length)
        end
      end,
      max_concurrency: System.schedulers_online()
    )
    |> Enum.reduce(%{}, fn {:ok, map}, acc ->
      Map.merge(acc, map, fn _key, val1, val2 -> val1 + val2 end)
    end)
    |> Map.filter(fn {k, _v} -> String.length(k) == kmer_length end)
    |> Map.filter(fn {k, _v} -> Kernel.not(String.contains?(k, "X") or String.contains?(k, "B") or String.contains?(k, "Z")) end)
  end
end
