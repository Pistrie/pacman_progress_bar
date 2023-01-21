defmodule PacmanProgressBar do
  @moduledoc """
  This module creates a progress bar based on Arch Linux's pacman package manager
  """

  @initial_pacman_character "c"
  @spacing_character " "
  @progress_character "-"
  @meal_character "o"
  @meal_spacing 2

  @spec render(number, number, keyword) :: nil | :ok
  @doc """
  Writes the progress bar to the terminal using IO.write/2. Calling this function again will overwrite the last progress bar. If all tasks are completed it will automatically print a newline character

  Use PacmanProgressBar.raw/2 to get the progress bar in the form of a string

  ## Options

  - `:use_color` (boolean) - set to true if you want the pacman character to be yellow
  - `:bar_size` (integer) - the amount of characters between the square brackets. A correct value can be calculated by changing `n` in `2 + (n * 3)`

  ## Examples

      iex> PacmanProgressBar.render(30, 7)
      #=> [------c o  o  o  o  o  o  o  ]  23%

      iex> PacmanProgressBar.render(30, 7)
           PacmanProgressBar.render(30, 10)
      #=> [---------C o  o  o  o  o  o  ]  33%
  """
  def render(total_tasks, completed_tasks, opts \\ [])

  def render(total_tasks, completed_tasks, opts) do
    IO.write("\r#{raw(total_tasks, completed_tasks, opts)}")

    if total_tasks == completed_tasks do
      IO.write("\n")
    end
  end

  @spec raw(number, number, keyword) :: nonempty_binary
  @doc """
  Returns the progress bar in the form of a string

  Use PacmanProgressBar.render/2 if you automatically want to write this string to the terminal

  ## Options

  - `:use_color` (boolean) - set to true if you want the pacman character to be yellow
  - `:bar_size` (integer) - the amount of characters between the square brackets. A correct value can be calculated by changing `n` in `2 + (n * 3)`

  ## Examples

      iex> PacmanProgressBar.raw(30, 7)
      #=> "[------c o  o  o  o  o  o  o  ]  23%"
  """
  def raw(total_tasks, completed_tasks, opts \\ [])

  def raw(total_tasks, completed_tasks, _opts) when completed_tasks > total_tasks,
    do: raise("completed_tasks cannot be higher than total_tasks")

  def raw(total_tasks, completed_tasks, opts) do
    bar_size = Keyword.get(opts, :bar_size)
    use_color? = Keyword.get(opts, :use_color)

    bar_size =
      if bar_size == nil or not is_number(bar_size) do
        determine_terminal_width() |> determine_bar_size()
      else
        bar_size
      end

    bar = initial_bar(bar_size)
    percentage_completed = percentage_completed(total_tasks, completed_tasks)
    destination_index = percentage_to_index(bar_size, percentage_completed)

    bar = move_pacman_to_index(bar, destination_index, 0, @initial_pacman_character, use_color?)
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
    |> Float.round(2)
    |> Kernel.*(100)
    |> trunc()
  end

  # initial_bar creates a progress bar where a meal is placed every x characters
  # where x is @meal_spacing
  defp initial_bar(bar_size, bar \\ "", counter \\ 0, mealcounter \\ 0)

  defp initial_bar(bar_size, bar, counter, _) when counter == bar_size,
    do: bar |> String.to_charlist()

  defp initial_bar(bar_size, bar, counter, mealcounter) when mealcounter == @meal_spacing do
    bar = bar <> @meal_character
    initial_bar(bar_size, bar, counter + 1)
  end

  defp initial_bar(bar_size, bar, counter, mealcounter) when counter < bar_size do
    bar = bar <> @spacing_character
    initial_bar(bar_size, bar, counter + 1, mealcounter + 1)
  end

  defp percentage_to_index(bar_size, percentage_completed),
    do: (percentage_completed / 100 * bar_size) |> Float.round() |> trunc()

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         _pacman_character,
         _use_color?
       )
       when current_index > destination_index,
       do: bar

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         pacman_character,
         use_color?
       )
       when current_index == 0 do
    bar =
      if use_color? == true do
        List.replace_at(bar, 0, pacman_character |> colorize_pacman_character)
      else
        List.replace_at(bar, 0, pacman_character)
      end

    pacman_character = alternate_pacman_character(pacman_character)

    move_pacman_to_index(
      bar,
      destination_index,
      current_index + 1,
      pacman_character,
      use_color?
    )
  end

  defp move_pacman_to_index(
         bar,
         destination_index,
         current_index,
         pacman_character,
         use_color?
       )
       when current_index <= destination_index do
    bar =
      if use_color? == true do
        bar = List.replace_at(bar, current_index, pacman_character |> colorize_pacman_character())
        List.replace_at(bar, current_index - 1, @progress_character)
      else
        bar = List.replace_at(bar, current_index, pacman_character)
        List.replace_at(bar, current_index - 1, @progress_character)
      end

    pacman_character =
      if rem(current_index, 2) == 0 do
        alternate_pacman_character(pacman_character)
      else
        pacman_character
      end

    move_pacman_to_index(
      bar,
      destination_index,
      current_index + 1,
      pacman_character,
      use_color?
    )
  end

  defp colorize_pacman_character(pacman_character) do
    IO.ANSI.yellow() <> pacman_character <> IO.ANSI.reset()
  end

  defp alternate_pacman_character(pacman_character) do
    case pacman_character do
      "c" -> "C"
      "C" -> "c"
    end
  end

  @fallback_width 80
  defp determine_terminal_width do
    case :io.columns() do
      {:ok, count} -> count
      _ -> @fallback_width
    end
  end

  defp determine_bar_size(terminal_width) do
    # (2 + (n * 3))
    # (2 + (32 * 3)) = 98, the maximum
    Enum.reduce_while(32..1, 0, fn n, bar_size ->
      possible_bar_size = 2 + n * 3

      if terminal_width - 7 >= possible_bar_size do
        {:halt, bar_size + possible_bar_size}
      else
        {:cont, bar_size}
      end
    end)
  end
end
