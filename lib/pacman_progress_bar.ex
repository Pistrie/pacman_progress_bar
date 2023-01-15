defmodule PacmanProgressBar do
  @moduledoc """
  This module creates a progress bar based on Arch Linux's pacman package manager
  """

  @initial_pacman_character "c"
  @progress_character "-"
  @meal_character "o"
  @meal_spacing 2
  # to make a nice bar the length has to be equal to (2 + (n * 3))
  # change n to get the new length value
  @bar_size 29
  # TODO create length based on width of terminal

  @spec render(number, number) :: nil | :ok
  @doc """
  Writes the progress bar to the terminal using IO.write/2. Calling this function again will overwrite the last progress bar. If all tasks are completed it will automatically print a newline character

  Use PacmanProgressBar.raw/2 to get the progress bar in the form of a string

  Returns `:ok`

  ## Examples

      iex> PacmanProgressBar.render(30, 7)
      #=> [------c-o--o--o--o--o--o--o--]  23%

      iex> defmodule Test do
             def function do
               PacmanProgressBar.render(30, 7)
               PacmanProgressBar.render(30, 10)
             end
           end
      #=> [---------C-o--o--o--o--o--o--]  33%
  """
  def render(total_tasks, completed_tasks) do
    IO.write("\r#{raw(total_tasks, completed_tasks)}")

    if total_tasks == completed_tasks do
      IO.write("\n")
    end
  end

  @spec raw(number, number) :: nonempty_binary
  def raw(total_tasks, completed_tasks) when completed_tasks > total_tasks,
    do: raise("completed_tasks cannot be higher than total_tasks")

  @doc """
  Returns the progress bar in the form of a string

  Use PacmanProgressBar.render/2 if you automatically want to write this string to the terminal

  ## Examples

      iex> PacmanProgressBar.raw(30, 7)
      #=> "[------c-o--o--o--o--o--o--o--]  23%"
  """
  def raw(total_tasks, completed_tasks) do
    bar = initial_bar()
    percentage_completed = percentage_completed(total_tasks, completed_tasks)
    destination_index = percentage_to_index(percentage_completed)

    bar = move_pacman_to_index(bar, destination_index, 0, @initial_pacman_character)
    "#{bar |> add_borders_to_bar()} #{percentage_completed |> format_percentage()}"
  end

  defp add_borders_to_bar(bar), do: "[#{bar}]"

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

  defp initial_bar(bar, counter, _) when counter == @bar_size, do: bar |> String.to_charlist()

  defp initial_bar(bar, counter, mealcounter) when mealcounter == @meal_spacing do
    bar = bar <> @meal_character
    initial_bar(bar, counter + 1)
  end

  defp initial_bar(bar, counter, mealcounter) when counter < @bar_size do
    bar = bar <> @progress_character
    initial_bar(bar, counter + 1, mealcounter + 1)
  end

  defp percentage_to_index(percentage_completed),
    do: (percentage_completed / 100 * @bar_size) |> Float.floor() |> trunc()

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         _
       )
       when current_index > destination_index,
       do: bar

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
