return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_python = require("dap-python")

			require("dapui").setup({
				-- Only the bottom panel (repl w/ action buttons + console), no left sidebar
				layouts = {
					{
						elements = {
							{ id = "repl", size = 0.4 },
							{ id = "console", size = 0.6 },
						},
						size = 12,
						position = "bottom",
					},
				},
			})
			require("nvim-dap-virtual-text").setup({
				commented = true, -- Show virtual text alongside comment
			})

			dap_python.setup("python3")

			-- Dart / Flutter -------------------------------------------------------------
			-- Lets <leader>dc run the `type = "dart"` entries of a repo's .vscode/launch.json.
			-- flutter-tools replaces dap.adapters.dart whenever :FlutterRun/:FlutterDebug is
			-- used, so the <leader>dc keymap re-applies this adapter before continuing.
			local flutter_bin = vim.fn.exepath("flutter")
			if flutter_bin == "" then
				flutter_bin = vim.fn.expand("~/fvm/default/bin/flutter")
			end

			local function is_desktop_or_web(device)
				local platform = device.targetPlatform or ""
				return platform:match("^darwin") ~= nil
					or platform:match("^web") ~= nil
					or platform:match("^linux") ~= nil
					or platform:match("^windows") ~= nil
			end

			local function has_device_flag(tool_args)
				for _, arg in ipairs(tool_args or {}) do
					if arg == "-d" or arg == "--device-id" or arg:match("^%-d=") or arg:match("^%-%-device%-id=") then
						return true
					end
				end
				return false
			end

			-- `flutter devices --machine` takes several seconds and enrich_config runs it
			-- before every launch, so cache the result briefly. Concurrent callers share one
			-- in-flight scan; an empty result is never cached, so unplugging and replugging a
			-- phone recovers on the next scan rather than sticking at "no devices".
			local DEVICES_TTL_MS = 120000
			local devices_cache = { ts = 0, list = nil }
			local devices_waiters = {}
			local devices_inflight = false

			local function flutter_devices(callback)
				local uv = vim.uv or vim.loop
				if devices_cache.list and (uv.now() - devices_cache.ts) < DEVICES_TTL_MS then
					return callback(devices_cache.list)
				end
				table.insert(devices_waiters, callback)
				if devices_inflight then
					return
				end
				devices_inflight = true
				vim.system({ flutter_bin, "devices", "--machine" }, { text = true }, function(result)
					local ok, devices = pcall(vim.json.decode, result.stdout or "")
					local list = (ok and type(devices) == "table") and devices or {}
					vim.schedule(function()
						devices_inflight = false
						if #list > 0 then
							devices_cache = { ts = uv.now(), list = list }
						end
						local waiters = devices_waiters
						devices_waiters = {}
						for _, cb in ipairs(waiters) do
							cb(list)
						end
					end)
				end)
			end

			local function register_dart_adapter()
				dap.adapters.dart = {
					type = "executable",
					command = flutter_bin,
					args = { "debug-adapter" },
					-- nvim-dap warns "Debug adapter didn't respond" if `initialize` takes longer
					-- than this. The default of 4s is tight when flutter has to wait on its
					-- startup lock (another flutter command running) or rebuild its snapshot.
					options = { initialize_timeout_sec = 15 },
					-- Pick a device before launching unless the config already names one.
					-- Phones/emulators are preferred; desktop and web only show up when
					-- nothing else is attached. A single candidate is used without asking.
					enrich_config = function(config, on_config)
						if config.request ~= "launch" or has_device_flag(config.toolArgs) then
							return on_config(config)
						end
						flutter_devices(function(devices)
							local mobile = vim.tbl_filter(function(d)
								return not is_desktop_or_web(d)
							end, devices)
							local candidates = #mobile > 0 and mobile or devices
							local function launch_on(device)
								local cfg = vim.deepcopy(config)
								cfg.toolArgs = cfg.toolArgs or {}
								vim.list_extend(cfg.toolArgs, { "-d", device.id })
								on_config(cfg)
							end
							if #candidates == 0 then
								return on_config(config)
							end
							if #candidates == 1 then
								return launch_on(candidates[1])
							end
							vim.ui.select(candidates, {
								prompt = "Flutter device",
								format_item = function(d)
									return string.format("%s  (%s)", d.name, d.targetPlatform)
								end,
							}, function(choice)
								if choice then
									launch_on(choice)
								end
							end)
						end)
					end,
				}
			end
			register_dart_adapter()

			-- Warm the device cache when a dart buffer opens so the first <leader>dc does
			-- not stall on the scan. Re-entrant calls collapse into the in-flight request.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dart",
				callback = function()
					flutter_devices(function() end)
				end,
			})

			vim.fn.sign_define("DapBreakpoint", {
				text = "",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "", -- or "❌"
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "", -- or "→"
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "DiagnosticSignWarn",
			})

			-- Automatically open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			-- DAP-UI console: follow output even when it's not the focused window,
			-- but don't yank you back down if you've scrolled up to read.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dapui_console",
				callback = function(args)
					local buf = args.buf
					vim.api.nvim_buf_attach(buf, false, {
						on_lines = function(_, _, _, _, last_old, _)
							vim.schedule(function()
								if not vim.api.nvim_buf_is_valid(buf) then
									return
								end
								local last = vim.api.nvim_buf_line_count(buf)
								for _, win in ipairs(vim.fn.win_findbuf(buf)) do
									-- only follow if the cursor was already at the old bottom
									if vim.api.nvim_win_get_cursor(win)[1] >= last_old then
										pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
									end
								end
							end)
						end,
					})
				end,
			})

			local opts = { noremap = true, silent = true }

			-- Toggle breakpoint
			opts.desc = "Toggle breakpoint"
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, opts)

			-- Continue / Start (re-applies the Dart adapter in case flutter-tools swapped it)
			opts.desc = "Continue / Start"
			vim.keymap.set("n", "<leader>dc", function()
				if vim.bo.filetype == "dart" then
					register_dart_adapter()
				end
				dap.continue()
			end, opts)

			-- Step Over
			opts.desc = "Step Over"
			vim.keymap.set("n", "<leader>do", function()
				dap.step_over()
			end, opts)

			-- Step Into
			opts.desc = "Step Into"
			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, opts)

			-- Step Out
			opts.desc = "Step Out"
			vim.keymap.set("n", "<leader>dO", function()
				dap.step_out()
			end, opts)

			-- Keymap to terminate debugging
			opts.desc = "Terminate debugging"
			vim.keymap.set("n", "<leader>dq", function()
				require("dap").terminate()
			end, opts)

			-- Flutter hot reload / restart for sessions started with <leader>dc
			opts.desc = "Flutter hot reload"
			vim.keymap.set("n", "<leader>dr", function()
				local session = dap.session()
				if session then
					session:request("hotReload", { reason = "manual" })
				end
			end, opts)

			opts.desc = "Flutter hot restart"
			vim.keymap.set("n", "<leader>dR", function()
				local session = dap.session()
				if session then
					session:request("hotRestart", { reason = "manual" })
				end
			end, opts)

			-- Clear all breakpoints
			opts.desc = "Clear all breakpoints"
			vim.keymap.set("n", "<leader>dB", function()
				dap.clear_breakpoints()
			end, opts)

			-- Toggle DAP UI
			opts.desc = "Toggle DAP UI"
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, opts)
		end,
	},
}
