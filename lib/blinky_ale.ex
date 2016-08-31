defmodule BlinkyAle do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # worker(BlinkyAle.Worker, [arg1, arg2, arg3]),
      worker(Task, [fn -> blink end], restart: :transient),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlinkyAle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def blink do
    :os.cmd '/usr/bin/pinmux set ephy gpio'
    {:ok, pid} = Gpio.start_link(43, :output)
    blink_forever(pid)
  end

  def blink_forever(pid) do
    Gpio.write(pid, 1)
    :timer.sleep(1000)
    Gpio.write(pid, 0)
    :timer.sleep(1000)
    blink_forever(pid)
  end
end
