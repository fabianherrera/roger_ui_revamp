defmodule RogerUI.Tests.RogerApiInMemory do
  @moduledoc """
  Mocks calls to Roger.Info API
  """

  # Partitions will be multiplied by 8 and queues by 24
  @generated_partitions_size Application.get_env(:roger_ui, :generated_partitions_size, 10)
  # Jobs will be multiplied by 12
  @generated_jobs_size Application.get_env(:roger_ui, :generated_jobs_size, 100)

  @partitions %{
    running: %{
      "roger_test_partition_1" => %{
        default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
        fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
        other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
      }
    },
    waiting: %{
      "roger_test_partition_2" => %{
        default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
        fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
        other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
      }
    }
  }

  @jobs %{
    "roger_demo_partition" => [
      %Roger.Job{
        args: %{
          "country" => "Venezuela",
          "email" => "janedoe@gmail.com",
          "name" => "Jane Doe",
          "number_of_pets" => 966
        },
        execution_key: nil,
        id: "16ovjr39jvijf4kgrlqe2ib2aadojhid",
        module: RogerDemo.Job.CreateUpdateUser,
        queue_key: nil,
        queued_at: 1_517_697_586_453,
        retry_count: 0,
        started_at: 1_517_697_682_999
      }
    ],
    "other_partition" => [
      %Roger.Job{
        args: %{
          "country" => "Venezuela",
          "email" => "janedoe@gmail.com",
          "name" => "Jane Doe",
          "number_of_pets" => 962
        },
        execution_key: nil,
        id: "38mkrss34n1uc4tdmulu4mqm4ic9a5t6",
        module: RogerDemo.Job.CreateUpdateUser,
        queue_key: nil,
        queued_at: 1_517_697_586_453,
        retry_count: 0,
        started_at: 1_517_697_682_981
      },
      %Roger.Job{
        args: %{
          "country" => "Venezuela",
          "email" => "janedoe@gmail.com",
          "name" => "Jane Doe",
          "number_of_pets" => 961
        },
        execution_key: nil,
        id: "5hm0u6cbeo8tdk6qkq0l8v6qgqnfhori",
        module: RogerDemo.Job.CreateUpdateUser,
        queue_key: nil,
        queued_at: 1_517_697_586_453,
        retry_count: 0,
        started_at: 1_517_697_682_981
      }
    ]
  }

  defp generator(times, map) do
    1..times
    |> Enum.reduce([], fn i, accum ->
      accum
      |> Keyword.put(:"server_#{i}@127.0.0.1", Map.new(map))
      |> Keyword.put(:"watcher_#{i}@127.0.0.1", Map.new(map))
      |> Keyword.put(:"other_#{i}@127.0.0.1", Map.new(map))
      |> Keyword.put(:"demo_#{i}@127.0.0.1", Map.new(map))
    end)
  end

  def partitions, do: generator(@generated_partitions_size, @partitions)

  def running_jobs(_partition_name), do: running_jobs()
  def running_jobs, do: generator(@generated_jobs_size, @jobs)

  def queued_jobs(_partition_name, _queue_name), do: @jobs |> Map.values() |> List.flatten()
end
