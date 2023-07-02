-- Time demo with signal handling fpr CTRL-C
local uv = require "luv"
local lsleep = require "lsleep"

local loopCycleMillis <const> = 1000

-- Create a handle to a uv_timer_t
local timer = uv.new_timer()
timer:set_repeat(loopCycleMillis)

-- Create a new signal handler
local signal = uv.new_signal()
-- Define a handler function
signal:start("sigint",
	     function(signal)
		-- print("got " .. signal .. ", shutting down")
		print("\nCTRL-C pressed. Shutting down.")
		timer:close()
		uv.stop()
		os.exit(1)
	     end
)

-- Callback function
function doStuff()
   local timestamp = os.date("%Y-%m-%d_%H:%M:%S")
   io.write(string.format("Tick! %s. Next due in: %dms.\n",timestamp,timer:get_due_in()))
   -- lsleep:sleep(5)
   timer:again()
end

-- This will wait loopCycleMillis ms and then continue inside the callback
timer:start(0, loopCycleMillis, doStuff)

-- uv.run will block and wait for all events to run.
-- When there are no longer any active handles, it will return
uv.run()
