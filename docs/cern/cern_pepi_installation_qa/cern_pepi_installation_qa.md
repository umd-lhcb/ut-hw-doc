This document is a draft to PEPI installation QA, mainly regarding the cable
connectivity test for now.

## Old method

1. Install Backplane to PEPI crate baseplate with a **custom BP support**

2. Install another **custom Inner BB support**

3. Install Inner BB, Telemetry BB, and P2B2 cables, then populate PPP

4. _To test power and sense lines_:
    1. Plug in **custom DCB and Pig Tail continuity testing boards**
    2. Turn on LVR _with_ sense lines connected channel-by-channel
    3. Measure the voltages on the continuity testing boards

5. Install Pig tails and the mechanical support for them

6. Remove all power cables, then remove the custom-made Inner BB support

7. Installed the DCB card guide, then remove custom-made BP support

8. Re-install power cables

### Problems with the old method

1. To remove the custom-made Inner BB support, all power cables have to be
    removed.

    This is because we have to re-use existing screw holes on the carbon fiber
    frame, and that means these screws will be blocked by power cables.

2. When removing power cables, we need to unplug them from PPP due to the fact
    that we cut them to exact lengths.

    This means that after replug, we have no continuity test to ensure all
    cables are populated correctly.


## Proposed method

1. Populate PPP

    !!! note
        - All cables from the Inner BB and P2B2 cables will be plugged in
        - For telemetry, we plugin the RJ45 connector without plugging in the MiniIO
            connector to the Telemetry BB.

2. _To test power lines_:
    1. Turn on LVR _without_ sense lines connected channel-by-channel
    2. Use a multimeter to measure voltage on the power cable/board BP side connectors

3. _To test sense lines_:
    1. Turn off all LVR channels
    2. Use a **MiniIO breakout board**, then apply voltage at a particular pair
        of sense line
    3. Read the sense line voltage at LVR with SCA ADC

4. Install BP with the **custom BP support**

5. Install Pig Tails and their mechanical support

6. Install DCB card guide

7. Install all power cables
    1. Install Telemetry BB
    2. Install P2B2 cables
    3. Install sense lines to Telemetry BB
    4. Install Inner BB
