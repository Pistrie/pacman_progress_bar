defmodule PacmanProgressBar do
  @progress_character "-"
  @meal_character "o"
  @meal_spacing 2
  @bar_size 30

  defp percentage_completed(total_tasks, completed_tasks) do
    (completed_tasks / total_tasks)
    |> Float.floor(2)
    |> Kernel.*(100)
    |> trunc()
  end

  def render do
    percentage_completed(30, 1)
  end
end
