Enum.each(0..100, fn i ->
  PacmanProgressBar.render(100, i)
  :timer.sleep 90
end)
