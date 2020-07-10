Title: LVR burn-in operations

Currently, LVR burn-in maximum capacity is 16 boards:
- 2 x `2V5` (using Switching Load Boards labeled 2V5)
- 14 x `1V2`/`1V5` (using the rest of Switching Load Boards)

Each batch should be burned-in for 48 hrs, with switching loads and thermal cycles. The current profile is:
- switching between high (normal) current for 50s and low current for 10s
  - so that voltage regulator chips are frequently exercised by changing states, while in typical operation (high current) most of the time    
- bang-bang controlling board temperature between ~30C and ~50C
  - for reference, constant-cooling equilibrium is ~28C and overtemperature lockout is 70C.
  
## Start burning in a new batch
- Inspect the "ready for burn-in" box and decide on the LVR types
- Make sure that the Maraton is off
- Update the database according to the selected LVRs' IDs
- Mount LVR in the SBC, and double-check that wedge locks are tightened
- Attach thermal sensors on 4 boards:
  - put sensor's flat side against an open area of the board (without SMD componments)
  - press the sticky putty to secure sensors in place
  - you'll have more room to work with before installing adjacent boards
- Connect the output cables to LVR, and double-check which switching load board the cables connect to
  - the output breakout boards are labeled for 2V5 
- Now install the input breakout boards and grounding cables:
  - move the horizontal bar back to make space for installation 
  - because there're 2 input breakout boards per Maraton channel, connect them in order and not mix between channels 
  - input breakout boards are hard to secure, so sometimes zip ties are needed
  - after all boards are connected (some horizontal tilt unavoidable), push and secure the bar
  - double-check the connectors, especially for vertical tilt (resulting in partial connection)
  - verify grounding cable connection
- Double-check that the chiller is on
- Turn on the Maraton
- Start running the python scripts as described in https://umd-lhcb.github.io/ut-hw-doc/burnin/burnin_sw_setup/#scripts-to-run-on-the-raspberry-pi
  - Note that you need to use `Ctrl` + `b` then arrow to switch tmux panel
  - You can use `Ctrl` + `r` to reverse search past command lines
- Turning on one Maraton channel (channel numbers are labeled on SBC) as described in https://umd-lhcb.github.io/ut-hw-doc/burnin/burnin_sw_setup/#controlling-the-psu-maraton-with-curl
  - after issuing command, verify all LEDs are on: 1 in the front **and 4 in the back**. If not, turn off the channel and check connections (e.g. only 4 LVR channels on due to partial input connection)
  - use multimeter to spot check voltages across the output breakout boards -- should be the set voltage plus some drop (e.g. 1V5+0.2V)
- Repeat for other channels
- At this point, all LVRs are running with low currents, before load-switching (seeing 5 Ohm fixed load)
- Make sure that the Switching Load Boards' secondary voltage supply is on (5V, 0A), and the cooling fans are on
- In another panel, start running the SwLoadTest.py (src/demo/SwLoadTest.py)
  - verify the changing current (2A/0A) on the voltage supply
- Now Switching Load Boards are in working state, LVRs are changing between high/low-current states and heating up quickly
- Go to http://129.2.92.92:56789/DVApp and verify the temperature measurements (should be going up from ~30C)
- Monitor and wait for the upper temperature target (40C), and verify the USB relay switched on (click and red LED)
  - now valve is open for cooling water
- Use FlIR camera to check for abnormally hot (>60C) spots, both on the LVRs and the SLBs
- Give yourself a pat on the back -- burn-in has started

## Stop the burn-in
