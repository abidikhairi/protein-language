defmodule Mix.Tasks.Merge do
  require Logger
  require Explorer.DataFrame, as: DF

  @spec run(list()) :: {String.t(), :ok}
  def run(args) do
    Logger.info("Merge task started: #{inspect(args)}")

    if length(args) != 2 do
      Logger.info("Error: Required 2 arguments, got #{length(args)}")
      Logger.info("Usage: merge <organism> <kmer-length>")
      System.halt(1)
    end

    organism = Enum.at(args, 0)
    kmer_length = Enum.at(args, 1)

    Logger.info("Merging data for organism: #{organism}")
    Logger.info("Kmer Length: #{kmer_length}")

    base_dir = "data/output/#{organism}"
    coverage_file = "#{base_dir}/coverage/k#{kmer_length}.csv"
    frequency_file = "#{base_dir}/frequency/k#{kmer_length}.csv"

    Logger.info("Merging files: #{coverage_file} and #{frequency_file}")

    coverage_df = Merge.read_coverage_file(coverage_file)
    wordcount_df = Merge.read_frequency_file(frequency_file)
    merged_data = DF.join(coverage_df, wordcount_df)

    merged_data = DF.put(
      merged_data,
      "organism",
      Explorer.Series.from_list(
        (1..DF.n_rows(merged_data)) |> Enum.map(fn _ -> organism end)
      )
    )

    output_file = "data/output/merged/#{organism}_k#{kmer_length}.csv"
    Logger.info("Saving merged dataframe in #{output_file}")

    DF.to_csv!(merged_data, output_file, [header: true, delimiter: ","])

    {"Data merged successfully!", :ok}
  end
end
