defmodule Mix.Tasks.Wordcount do
  require Logger
  require Explorer.DataFrame, as: DF

  @spec run(list()) :: {String.t(), :ok}
  def run(args) do

    if length(args) != 6 do
      Logger.error("Error: Required 5 arguments, got #{length(args)}")
      Logger.info("Usage: wordcount path/to/sequences.tab <delimiter> <seq-index> <kmer-length> <save-file> <task>")
      System.halt(1)
    end

    sequence_file = Enum.at(args, 0)
    delimiter = Enum.at(args, 1)
    {seq_index, ""} = Integer.parse(Enum.at(args, 2))
    {kmer_length, ""} = Integer.parse(Enum.at(args, 3))
    output_file = Enum.at(args, 4)
    task = String.to_atom(Enum.at(args, 5))

    Logger.info("Reading input file #{sequence_file}, delimiter: '#{delimiter}'")
    Logger.info("Task: #{task}, kmer-length: #{kmer_length}")

    sequences = SequenceReader.read_tabular_file(sequence_file, delimiter, seq_index)
    Logger.info("Read #{Enum.count(sequences)} sequences")

    Logger.info("Counting words of length #{kmer_length}")
    wordcount_dict = Wordcount.wordcount(sequences, kmer_length, task)

    Logger.info("Found #{Enum.count(wordcount_dict)} words")


    wordcount_df = DF.new(%{
      word: wordcount_dict |> Enum.map(fn {k, _} -> k end),
      count: wordcount_dict |> Enum.map(fn {_, v} -> v end),
    })
    |> DF.select(["word", "count"])
    |> DF.sort_by(desc: count)
    |> DF.put("rank", Enum.to_list 1..(Enum.count(wordcount_dict)))

    Logger.info("Saving output to #{output_file}")
    wordcount_df
    |> DF.to_csv(output_file, [header: true, delimiter: ","])

    {"File saved at: #{output_file}", :ok}
  end
end
