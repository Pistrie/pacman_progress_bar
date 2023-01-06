defmodule PacmanProgressBar do
  @progress_character "-"
  @meal_character "o"
  @meal_spacing 2
  @bar_size 14

  def render do
    initial_bar()
  end

  # initial_bar creates a progress bar where a meal is placed every x characters
  # where x is @meal_spacing
  defp initial_bar(bar \\ "", counter \\ 0, mealcounter \\ 0)

  defp initial_bar(bar, counter, _) when counter == @bar_size do
    bar
  end

  defp initial_bar(bar, counter, mealcounter) when mealcounter == @meal_spacing do
    bar = bar <> @meal_character
    initial_bar(bar, counter + 1)
  end

  defp initial_bar(bar, counter, mealcounter) when counter < @bar_size do
    bar = bar <> @progress_character
    initial_bar(bar, counter + 1, mealcounter + 1)
  end
end
