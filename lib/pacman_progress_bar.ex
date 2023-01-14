defmodule PacmanProgressBar do
  @progress_character "-"
  @meal_character "o"
  @meal_spacing 2
  @bar_size 29
  # to make a nice bar the length has to be equal to (2 + (n * 3))
  # change n to get the new length value

  def render do
    "#{initial_bar()} #{percentage_completed(30, 0)}%"
  end

  defp add_borders_to_bar(bar) do
    "[#{bar}]"
  end

  defp percentage_completed(total_tasks, completed_tasks) do
    (completed_tasks / total_tasks)
    |> Float.floor(2)
    |> Kernel.*(100)
    |> trunc()
  end

  # initial_bar creates a progress bar where a meal is placed every x characters
  # where x is @meal_spacing
  defp initial_bar(bar \\ "", counter \\ 0, mealcounter \\ 0)

  defp initial_bar(bar, counter, _) when counter == @bar_size do
    add_borders_to_bar(bar)
  end

  defp initial_bar(bar, counter, mealcounter) when mealcounter == @meal_spacing do
    bar = bar <> @meal_character
    initial_bar(bar, counter + 1)
  end

  defp initial_bar(bar, counter, mealcounter) when counter < @bar_size do
    bar = bar <> @progress_character
    initial_bar(bar, counter + 1, mealcounter + 1)
  end

  # TODO move pacman to the index corresponding to the percentage completed
  # make sure that the character behind pacman gets turned into @progress_character when moving him
end
