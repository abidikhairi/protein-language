defmodule Merge do
  require Explorer.DataFrame, as: DF

  @spec read_coverage_file(String.t()) :: DF.t()
  def read_coverage_file(input_file) do
    read_dataframe(input_file, "coverage")
  end

  @spec read_frequency_file(String.t()) :: DF.t()
  def read_frequency_file(input_file) do
    read_dataframe(input_file, "frequency")
  end

  @spec read_dataframe(String.t(), String.t()) :: DF.t()
  defp read_dataframe(input_file, column_name) do
    DF.from_csv!(input_file)
      |> DF.rename(%{"count" => column_name})
      |> DF.select(["word", column_name])
  end
end
