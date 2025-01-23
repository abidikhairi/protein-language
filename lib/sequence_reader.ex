defmodule SequenceReader do
  @moduledoc """
  Sequence file reader.
  """

  @doc """
  Read sequences from tabular file.

  ## Examples

      iex> SequenceReader.read_tabular_file("data/sequences.csv", ",", 1)
      ["MGLEALVPLAM", "MFRRLTFAQ", "MVIMSEFSA", "MRWQEMGYIFYPRKLR", "MTQRAGAAMLPSALLLLCV"]

      iex> SequenceReader.read_tabular_file("data/sequences.tsv", "\t", 1)
      ["MGLEALVPLAM", "MFRRLTFAQ", "MVIMSEFSA", "MRWQEMGYIFYPRKLR", "MTQRAGAAMLPSALLLLCV"]
  """
  @spec read_tabular_file(
          String.t(),
          String.t(),
          number()
        ) :: list()
  def read_tabular_file(input_file, delimiter, seq_index) do
    File.stream!(input_file)
      |> Enum.filter(fn line -> !String.contains?(line, "Entry") end)
      |> Enum.map(fn line -> String.split(line, delimiter) end)
      |> Enum.map(fn chunks -> Enum.at(chunks, seq_index) end)
      |> Enum.map(&String.trim/1)
  end

end
