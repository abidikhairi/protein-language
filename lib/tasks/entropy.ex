defmodule Mix.Tasks.Entropy do
  require Logger
  require Explorer.DataFrame, as: DF

  @spec run(list()) :: {String.t(), :ok}
  def run(args) do
    Logger.info("Entropy task started: #{inspect(args)}")

    if length(args) != 3 do
      Logger.info("Error: Required 3 arguments, got #{length(args)}")
      Logger.info("Usage: entropy path/to/word/frequency.csv <kmer-length> <level>")
      System.halt(1)
    end

    frequency_file = Enum.at(args, 0)
    kmer_length = String.to_integer(Enum.at(args, 1))
    level = Enum.at(args, 2)

    Logger.info("Reading input file #{frequency_file}")
    Logger.info("Kmer length: #{kmer_length}")

    frequency_df = DF.from_csv!(frequency_file)

    # If level not defined, then the entropy will be calculated for the whole word p(X), X is the word
    # Otherwise, the entropy will be calculated for the amino acid p(X), X is the amino acid
    case level do
      "letter" ->
        frequency_df =
          frequency_df["word"]
          |> Explorer.Series.to_list()
          |> Enum.map(&Wordcount.frequency(&1, 1))
          |> Enum.reduce(%{}, fn map, acc ->
            Map.merge(acc, map, fn _key, value1, value2 -> value1 + value2 end)
          end)
          |> Enum.map(fn {k, v} -> %{letter: k, count: v} end)
          |> DF.new()
          entropy = calculate_entropy(frequency_df)
          Logger.info("Entropy: #{entropy} bits for k = #{kmer_length}")
        _ ->
          entropy = calculate_entropy(frequency_df)
          Logger.info("Entropy: #{entropy} bits for k = #{kmer_length}")
    end

    {"Entropy calculated successfully", :ok}
  end

  @spec calculate_entropy(Explorer.DataFrame.t()) :: float
  defp calculate_entropy(df) do
    total_frequency = Explorer.Series.sum(df["count"])

    df = DF.put(df, "p_x", Explorer.Series.to_list(df["count"]) |> Enum.map(&(&1 / total_frequency)))

    df = DF.put(df, "p_x_log2", Explorer.Series.to_list(df["p_x"]) |> Enum.map(&:math.log2(&1)))

    entropy =
      Enum.zip(
        Explorer.Series.to_list(df["p_x"]),
        Explorer.Series.to_list(df["p_x_log2"])
      )
      |> Enum.map(fn {p_x, p_x_log2} -> p_x * p_x_log2 end)
      |> Enum.sum()
      |> Kernel.*(-1)

      entropy
  end
end
