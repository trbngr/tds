defmodule PLPTest do
  import Tds.TestHelper
  require Logger
  use ExUnit.Case, async: true

  @tag timeout: 50000

  setup do
    opts = Application.fetch_env!(:mssql, :opts)
    {:ok, pid} = Tds.start_link(opts)

    {:ok, [pid: pid]}
  end

  test "Max and Large PLP returns", context do
    query("DROP TABLE plp_test", [])
    query("""
      CREATE TABLE plp_test (
        text nvarchar(max)
      )
    """, [])
    data = File.read!("#{__DIR__}/plp_data.txt")
    query("INSERT INTO plp_test VALUES(@1)",[%Tds.Parameter{name: "@1", value: data, type: :string}])
    assert [[data]] == query("SELECT text FROM plp_test",[])
    query("DROP TABLE plp_test", [])
  end
end
