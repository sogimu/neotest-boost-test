local utils = require("neotest-boost-test.utils")
local parse = require("neotest-boost-test.parse")
local Report = require("neotest-boost-test.report")
local Adapter = require("neotest-boost-test.neotest_adapter")
local config = require("neotest-boost-test.config")

local BoostTestNeotestAdapter = { name = "neotest-boost-test" }
---@param args neotest.RunArgs
---@return nil | neotest.RunSpec[]
function BoostTestNeotestAdapter.build_spec(args)
  args.extra_args = args.extra_args or config.extra_args
  return Adapter:new(args):build_specs()
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
function BoostTestNeotestAdapter.results(spec, result, tree)
  local converter = Report.converter:new(spec, result, tree)
  return converter:make_neotest_results()
end

BoostTestNeotestAdapter.root = utils.normalized_root
BoostTestNeotestAdapter.setup = function(user_config)
  config.setup(user_config)
  require("neotest-boost-test.executables").set_summary_autocmd()
  return BoostTestNeotestAdapter
end

BoostTestNeotestAdapter.discover_positions = parse.parse_positions
BoostTestNeotestAdapter.is_test_file = function(path)
  return config.is_test_file(path)
end
BoostTestNeotestAdapter.filter_dir = function(name, relpath, root)
  return config.filter_dir(name, relpath, root)
end

return BoostTestNeotestAdapter
