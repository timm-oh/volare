:logger.debug("""
  > `docker attach $(docker compose ps web -q)` to attach IEx.pry()
  > Ctrl + P + Q to detach from the container terminal
""")
