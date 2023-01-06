defmodule Count do
  def count(0) do
    IO.puts("\nDone!")
  end

  def count(current) do
    IO.write("\r#{current} ")
    Process.sleep(1_000)
    count(current - 1)
  end
end
