## Overview

Currently, LVR burn-in maximum capacity is 16 boards:

- 2 x `2V5` (using Switching Load Boards labeled 2V5)
- 14 x `1V2`/`1V5` (using the rest of Switching Load Boards)

Each batch should be burned-in for 48 hrs, with switching loads and thermal cycles. The current profile is:

- switching between high current (2A) for 60s and low current (0.5A) for 10s
    
    !!! info
        So that voltage regulator chips are frequently exercised by changing
          states, while in typical operation (high current) most of the time

- bang-bang controlling board temperature between ~30C and ~50C

    !!! info
        For reference, constant-cooling equilibrium is ~30C and overtemperature lockout is 70C.

![SBC front view](SBC_front.jpg)
![SBC back view](SBC_back.jpg)


## Start burning in a new batch

1. Inspect the "ready for burn-in" box and decide on the LVR types
2. Update the database according to the selected LVRs' IDs
3. Check to make sure that wedgelocks' allen heads are facing the output side, not the input side; and verify the switches as indicated in the table below. Order refers to toggles 1234 on the switch, with `1` meaning `ON`. (CCM) or (FPGA) refer to the side of the LVR the switch is on. There are four SW6 switches.
    ![](../../lvr/lvr_qa/table_switches.png)
4. Mount LVR in the SBC, and double-check that wedge locks are tightened
5. Check the status of Maraton 

    !!! warning
        If it's already running for DCB burn-in, be careful not to touch exposed live wires in the lower SBC

6. Attach thermal sensors on 4 boards:
    1. put sensor's flat side against an open area of the board (without SMD componments)
    2. press the sticky putty to secure sensors in place
    3. you'll have more room to work with before installing adjacent boards

7. Connect the output cables to LVR (the connectors should click), and verify that 2V5 switching load boards are connecting to two LVRs in Maraton channel 11. 

    !!! info
        The output breakout boards are labeled for 2V5
        
    !!! warning
        As you connect the output cables, take care not to pull thermal sensors away from the boards

8. Now install the input breakout boards and grounding cables:
    1. move the horizontal bar back to make space for installation
    2. because there are 2 input breakout boards per Maraton channel, connect
        the pairs in order (e.g. from right to left) to not mix between channels
    3. input breakout boards are hard to secure even with the bar, so sometimes zip ties are needed (2V5 slots in particular)
    4. check that the cables to the input BBs are tightly connected to the block terminals (they gradually loosen and should be tightened again)
    5. after all boards are connected (some horizontal tilt unavoidable), push in the boards and fix the bar to keep boards in place (with quite some force, try starting from one end and push in one input BB at a time) 
    6. double-check the connectors, especially for vertical tilt (resulting in partial connection)
    7. verify grounding cable connection

9. Double-check that the chiller is on
10. Turn on the Maraton

11. Start running the python scripts as described in [here](../burnin_sw_setup.md#scripts-to-run-on-the-raspberry-pi)
    1. Note that you need to use `Ctrl` + `b` then arrow to switch `tmux` panel
    2. You can use `Ctrl` + `r` to reverse search past command lines

12. Turning on one Maraton channel (channel numbers are labeled on SBC) as described in [here](../burnin_sw_setup.md#controlling-the-psu-maraton-with-curl)
    1. after issuing command, verify all LEDs are on: 1 in the front **and 4 in the back**. If not, turn off the channel and check connections (e.g. only 4 LVR channels on due to partial input connection). Often the last few channels (11,10,9) need adjusting input BB connections (e.g. pushing in more).  
    2. use multimeter to spot check voltages across the output connector solder joints (or output breakout boards) -- should be the set voltage plus some drop (e.g. 1V5+0.2V)

13. Repeat for other channels
14. At this point, all LVRs are running with low currents, before load-switching (seeing 5 Ohm fixed load)
15. Make sure that the Switching Load Boards' secondary voltage supply is on
    (5V, 0A), and the cooling fans are on

16. In another panel, start running the `SwLoadTest.py` (`src/demo/SwLoadTest.py`)

    !!! note
        Verify the changing current (2A/0A) on the voltage supply

17. Now Switching Load Boards are in working state, LVRs are changing between
    high/low-current states and heating up quickly
18. Go to [monitoring website](http://129.2.92.92:56789/DVApp) and verify the temperature
    measurements (should be going up from ~30C)

19. Monitor and wait for the upper temperature target (40C), and verify the USB
    relay switched on (click and red LED)

    !!! info
        Now valve is open for cooling water

20. Use FLIR camera to check for abnormally hot (>60C) spots, both on the LVRs and the SLBs
21. Give yourself a pat on the back -- burn-in has started


## Stop the burn-in

1. Before turning off the Maraton channels, check that:
    1. In the web monitoring history, each Maraton channel's current did not deviate from its high and low values (e.g. reducing to half if 1 LVR stopped working)
    2. all 4 LEDs on the back are on (indicating all 8 LVR channels have been on).
    3. no hot spot >60C on FLIR
    4. Spot check voltages on output breakout boards, e.g. 1V5 + ~0.2V drop. Very carefully probe between two adjecent groups of pins on output connector (slowly move one probe at a time to avoid shorting). Will add picture here later.    

2. Turn off Maraton channels one by one.

    !!! note
        Verify that the front LEDs are off

3. Stop the control and monitoring scripts (`CtrlServer.py`, `CtrlClient.py`, `SwLoadTest.py`) by `Ctrl` + `C`

    !!! note
        You need to use `Ctrl` + `b` then arrow to switch tmux panel
        
        Some transmission failure messages may have covered the panel running `CtrlClient.py`

        For future convenience: after scripts are stopped, `Ctrl` + `L` to
        clear, then up arrow to bring up the last command
    
    !!! note 
        USB relay should be automatically set to open (no red LED on) when scripts are stopped, if the last measured temperature is higher than the lower target (31C). 
        If relay is closed, the DC power supply will keep pushing the solenoid valve on (not ideal). To open it by command line, refer to the burn-in software doc. 

4. Disconnect the output cables and hang them by their clip on the red wire.

5. Disconnect the input breakout boards (after moving the SBC bar)

    !!! note
        Check for loose connections to the terminal blocks (can gently pull to see if a wire is loose)

6. Disconnect the grounding wires

7. Loosen the wedge locks and take out LVRs. Detach the thermal sensors as space around LVR opens up.  

    !!! warning
        Take care not to pull wires off the sensors' leads
        
    !!! note
        Wedge locks should be loose after 3 complete turns. 
        If you still have trouble moving the LVR, make sure it's not blocked by the crate's bottom horizontal rail. 

8. Put the LVRs into ESD bags, and update the database

## Monitoring from off-campus

To visit the [monitoring website](http://129.2.92.92:56789/DVApp) from off-campus, you can set up VPN this way:

- Install the VPN client software from [UMD terpware](https://terpware.umd.edu/Windows/title/1840). (You want to select your OS and find it under Network.) 

- Login with your UMD account to connect to vpn.umd.edu (and select Group UMD)
