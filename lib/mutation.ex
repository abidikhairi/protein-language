defmodule Mutation do
  require Explorer.DataFrame, as: DF

  @spec get_mutated_sequence(map()) :: map()
  defp get_mutated_sequence(row) do
    sequence = Map.get(row, "Sequence")
    position = Map.get(row, "Position")
    mutation = Map.get(row, "Mutation")

    mutated_sequence = Enum.join([
      String.slice(sequence, 0, position - 1),
      mutation,
      String.slice(sequence, position, String.length(sequence))
    ])

    Map.put(row, "MutatedSequence", mutated_sequence)
  end

  @spec add_words_columns(DF.t()) :: DF.t()
  def add_words_columns(df) do
    DF.to_rows(df)
    |> Enum.map(fn row -> Map.put(row, "Word", String.split(Map.get(row, "CC"), "#") |> Enum.at(0)) end)
    |> Enum.map(fn row -> Map.put(row, "Mutation", String.split(Map.get(row, "CC"), "#") |> Enum.at(1)) end)
    |> DF.new
  end

  @spec get_words_pairs(map()) :: [String.t()]
  defp get_words_pairs(row) do
    original_words = String.split(Map.get(row, "OriginalWords"), "#")
    mutated_words = String.split(Map.get(row, "MutatedWords"), "#")

    Enum.zip(original_words, mutated_words)
      |> Enum.map(fn {original, mutated} -> "#{original}##{mutated}" end)
  end

  @spec get_pairs(DF.t()) :: DF.t()
  def get_pairs(df) do
    DF.to_rows(df)
    |> Enum.map(fn row -> Map.put(row, "CC", get_words_pairs(row)) end)
    |> DF.new
  end

  @spec get_mutated_sequences(DF.t()) :: DF.t()
  def get_mutated_sequences(df) do
    DF.to_rows(df)
    |> Enum.map(&get_mutated_sequence/1)
    |> DF.new
  end

  @spec get_words(DF.t()) :: DF.t()
  def get_words(df) do
    DF.to_rows(df)
    |> Enum.map(&extract_original_words/1)
    |> Enum.map(&extract_mutated_words/1)
    |> DF.new
  end

  @spec extract_original_words(map()) :: map()
  def extract_original_words(row) do
    sequence = Map.get(row, "Sequence")
    position = Map.get(row, "Position") - 1
    kmer_length = Map.get(row, "KmerLength")

    Map.put(row, "OriginalWords", extract_words(sequence, position, kmer_length))
  end

  @spec extract_mutated_words(map()) :: map()
  def extract_mutated_words(row) do
    sequence = Map.get(row, "MutatedSequence")
    position = Map.get(row, "Position") - 1
    kmer_length = Map.get(row, "KmerLength")

    Map.put(row, "MutatedWords", extract_words(sequence, position, kmer_length))
  end

  @spec extract_words(String.t(), pos_integer(), pos_integer()) :: String.t()
  defp extract_words(sequence, position, kmer_length) do
    start_index = position - kmer_length + 1

    Enum.to_list(start_index..(start_index + kmer_length - 1))
      |> Enum.map(&String.slice(sequence, &1, kmer_length))
      |> Enum.filter(&String.length(&1) == kmer_length)
      |> Enum.join("#")
  end

end
