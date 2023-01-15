defmodule PacmanProgressBar do
  @initial_pacman_character "c"
  @progress_character "-"
  @meal_character "o"
  @meal_spacing 2
  @bar_size 29
  # to make a nice bar the length has to be equal to (2 + (n * 3))
  # change n to get the new length value
  # TODO create length based on width of terminal

  def render do
    bar = initial_bar()
    percentage_completed = percentage_completed(30, 25)
    destination_index = percentage_to_index(percentage_completed)

    bar = move_pacman_to_index(bar, destination_index, 0, @initial_pacman_character)
    "#{bar |> add_borders_to_bar()} #{percentage_completed |> format_percentage()}"
  end

  def render_test_progression do
    bar = initial_bar()

    Enum.each(0..30, fn tasks_completed ->
      percentage_completed = percentage_completed(30, tasks_completed)
      destination_index = percentage_to_index(percentage_completed)
      bar = move_pacman_to_index(bar, destination_index, 0, @initial_pacman_character)

      "\r#{bar |> add_borders_to_bar()} #{percentage_completed |> format_percentage()}"
      |> IO.write()

      :timer.sleep(500)
    end)

    IO.puts("")
  end

  defp add_borders_to_bar(bar) do
    "[#{bar}]"
  end

  defp format_percentage(percentage) do
    cond do
      percentage < 10 -> "  #{percentage}%"
      percentage < 100 -> " #{percentage}%"
      percentage == 100 -> "#{percentage}%"
    end
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
    bar |> String.to_charlist()
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
  defp percentage_to_index(percentage_completed) do
    (percentage_completed / 100 * @bar_size) |> Float.floor() |> trunc()
  end

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         pacman_character
       )
       when current_index > destination_index do
    bar
  end

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         pacman_character
       )
       when current_index == 0 do
    bar = List.replace_at(bar, 0, pacman_character)

    pacman_character = alternate_pacman_character(pacman_character)

    move_pacman_to_index(
      bar,
      destination_index,
      current_index + 1,
      pacman_character
    )
  end

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         pacman_character
       )
       when current_index <= destination_index do
    bar = List.replace_at(bar, current_index, pacman_character)
    bar = List.replace_at(bar, current_index - 1, @progress_character)

    pacman_character = alternate_pacman_character(pacman_character)

    move_pacman_to_index(
      bar,
      destination_index,
      current_index + 1,
      pacman_character
    )
  end

  defp alternate_pacman_character(pacman_character) do
    case pacman_character do
      "c" -> "C"
      "C" -> "c"
    end
  end
end
