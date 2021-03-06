defmodule Atlas.Database.Adapter do
  @moduledoc """
  Defines the behaviour for an Atlas database adapter
  """

  use Behaviour

  alias Atlas.Database.Server.ConfigInfo

  defcallback connect(config_info :: ConfigInfo) :: { :ok, pid } |
                                                    { :error, term }


  @doc """
  Executes raw query. The query results must be of the form:
    {:ok, count, cols, rows}
    or
    {:error, reason}

  with values normalized using `Atlas.Database.FieldNormalizer`
  """
  defcallback execute_query(pid, query :: binary) :: { :ok, count :: integer, cols :: list, rows :: list } |
                                                     { :error, term }


  @doc """
  Execute prepared query when given 'normalized' SQL string and bound arguments.
  Normalized prepared queries use "?" to bind arguments. Internally it is the
  responsibility of the adpater to convert this to a 'native' binding of the
  driver library.

  The query results must be of the form:
    {:ok, {count, cols, rows}}
    or
    {:error, reason}

  with values normalized using `Atlas.Database.FieldNormalizer`
  """
  defcallback execute_prepared_query(pid, query :: String.t , args :: list) :: { :ok, prepared_query :: String.t } |
                                                                             { :error, any }

  defcallback quote_column(column :: String.t) :: String.t

  defcallback quote_tablename(table :: String.t) :: String.t

  defcallback quote_namespaced_column(table :: String.t, column :: String.t) :: String.t
end
