defmodule ProgressBar do
  @rounding_precision 2
  @progress_bar_size 50
  @complete_character "█"
  @incomplete_character "░"

  def bar(count, total) do
    percent = percent_complete(count, total)
    divisor = 100 / @progress_bar_size

    complete_count = round(percent / divisor)
    incomplete_count = @progress_bar_size - complete_count

    complete = String.duplicate(@complete_character, complete_count)
    incomplete = String.duplicate(@incomplete_character, incomplete_count)

    "#{complete}#{incomplete}  (#{percent}%)"
  end

  defp percent_complete(count, total) do
    (100.0 * count / total) |> Float.round(@rounding_precision)
  end

  def start_bar do
    total = 50

    Enum.each(1..total, fn task ->
      IO.write("\r#{ProgressBar.bar(task, total)}")
      Process.sleep(50)
    end)

    IO.write("\n")
  end
end
