defmodule Mix.Tasks.Mutation do
  require Logger
  require Explorer.DataFrame, as: DF

  @spec run(list()) :: {String.t(), :ok}
  def run(args) do
    Logger.info("Mutation task started: #{inspect(args)}")
    if length(args) != 3 do
      Logger.info("Error: Required 3 arguments, got #{length(args)}")
      Logger.info("Usage: mutation path/to/mutations.csv <kmer-length> <save-file>")
      System.halt(1)
    end

    mutation_file = Enum.at(args, 0)
    kmer_length = String.to_integer(Enum.at(args, 1))
    output_file = Enum.at(args, 2)

    Logger.info("Kmer-length: #{kmer_length}")
    Logger.info("Reading input file #{mutation_file}")

    mutation_df = DF.from_csv!(mutation_file)
    num_mutations = DF.n_rows(mutation_df)

    Logger.info("Read #{num_mutations} mutations")

    mutation_df = mutation_df
      |> DF.put("KmerLength", Enum.map(1..num_mutations, fn _ -> kmer_length end))
      |> Mutation.get_mutated_sequences()
      |> Mutation.get_words()
      |> Mutation.get_pairs()
      |> DF.explode("CC")
      |> Mutation.add_words_columns()
      |> DF.select(["Entry", "Word", "Mutation"])

    Logger.info("Mutation DataFrame Constructed Successfully, Now lookup for coverage value")

    coverage_file = "data/output/homosapiens/coverage/k#{kmer_length}.csv"

    coverage_df = DF.from_csv!(coverage_file)
      |> DF.to_rows()
      |> Enum.map(fn row -> {Map.get(row, "word"), Map.get(row, "count")} end)
      |> Map.new()

    mutation_df = mutation_df
      |> DF.to_rows()
      |> Enum.map(fn row -> Map.put(row, "Cov1", Map.get(coverage_df, Map.get(row, "Word", 0))) end)
      |> Enum.map(fn row -> Map.put(row, "Cov2", Map.get(coverage_df, Map.get(row, "Mutation", 0))) end)
      |> DF.new()
      |> DF.select(["Entry", "Word", "Mutation", "Cov1", "Cov2"])

    num_rows = DF.n_rows(mutation_df)
    matched_cases = mutation_df |> DF.filter(col("Cov2") > col("Cov1")) |> DF.n_rows()

    Logger.info("Matched cases: #{matched_cases} out of #{num_rows} rows (#{matched_cases / num_rows * 100}%)")

    Logger.info("Saving output to #{output_file}")

    mutation_df
    |> DF.to_csv(output_file, [header: true, delimiter: ","])

    {"Mutation task terminated successfully", :ok}
  end

end
