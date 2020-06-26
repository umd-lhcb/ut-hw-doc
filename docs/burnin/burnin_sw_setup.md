The software for the burn-in is divided into to parts:

1. The sensor readout and hardware control are running on the Raspberry Pi
2. The data collection of sensor readouts and data visualization are on
    Yipeng's desktop computer (referred as `Julian` in the following sections)


## Installation
After clone the [`NeoBurnIn`](https://github.com/umd-lhcb/NeoBurnIn.git) to the
pi, run `nix-shell` in the project root. This will automatically install all
required dependencies.

!!! note
    The pi must be running on NixOS for `nix-shell` to work!

!!! note
    After `nix-shell` finishes executing, you'll be dropped in a shell.
    **Only** in this shell one can run burn-in related scripts.


## Scripts to run on the Raspberry Pi
To start the burn-in testing one should issue the command `tmux`
and then open three separate panels using the key combination
`Ctrl+A+"`. One can open more panels if needed although three
panels should be sufficient to run the burn-in:

1. In the first panel, run `CtrlServer.py` using the command
    ```
    ./CtrlServer.py --config-file ./config/burn_in_ctrl_server.yml
    ```

2. In the second panel, run `CtrlClient.py` using the command
    ```
    ./CtrlClient.py --config-file ./config/burn_in_ctrl_client.yml
    ```

3. The third panel is reserved for interactive use, such as controlling the
    MARATON or USB relay.

!!! note
    To navigate between `tmux` panels, type `Ctrl+A+up/down arrow keys` in
    order to move up/down between panels.

To stop the burn-in testing, navigate to each `tmux` panel which is running and
type `Ctrl+C` in order to issue a keyboard interrupt which will stop the code
from running. After all codes are stopped, one can exit `tmux` panels by
issuing the command `exit` within each panel.

!!! warning
    The `CtrlClient.py` should be stoped after a burn-in is finished, to avoid
    collecting idle MARATON current readouts.


## Scripts to run on `Julian`
Yipeng will take care of that. The gist is that `DataServer.py` and another
data visualization script will be running on `Julian`


## Controlling the PSU (MARATON) with `curl`
`CtrlServer.py` is required to control PSU remotely.

To turn on/off a MARATON channel, use the commands
```
curl -X POST http://192.168.1.30:45679/psu/192.168.1.31/<CHANNEL_NUMBER>/on
curl -X POST http://192.168.1.30:45679/psu/192.168.1.31/<CHANNEL_NUMBER>/off
```

!!! note
    `<CHANNEL_NUMBER>` is the number of the MARATON channel which one would like to turn on/off.

    There are 12 MARATON channels that can be turned on/off, ranging from
    channel 1 to channel 12.

    If changing the MARATON channel on/off is successful then the terminal will
    output `Success` and the LEDs on the LVRs for that MARATON channel will
    turn on/off respectively.

!!! warning
    WEINER control software on Windows numbers MARATON channel in a different way:
    Starting from 0 to 11 (instead of 1 to 12).

    This means that issuing the `curl` command to turn on channel 1 will turn
    on the channel labeled 0 on the WEINER control software. If one is not
    using the WEINER control software to monitor the MARATON channels then do
    not worry about this numbering offset.


## Controlling the USB relay with `curl`
`CtrlServer.py` is required to control PSU remotely.

To turn on/off a USB relay channel, use the commands
```
curl -X POST http://192.168.1.30:45679/relay/0001:0014:00/<CHANNEL_NUMBER>/on
curl -X POST http://192.168.1.30:45679/relay/0001:0014:00/<CHANNEL_NUMBER>/off
```

!!! note
    `<CHANNEL_NUMBER>` is the number of the USB relay channel which one would
    like to turn on/off.

    There are only two USB relay channels, channel 1 and channel 2,
    and only one channel will need to be turned on/off.

    This is because only one channel will be connected to a solenoid valve for
    the burn-in (as of 3/26/20). To see which channel one must turn on/off with
    `curl` commands one must inspect the hardware setup of the system, although
    the hardware should be setup such that the solenoid valve is connected to
    channel 2 of the USB relay.

!!! warning
    The number `0001:0014:00` in the `curl` commands **can change** and one should
    check if this number has changed **before** issuing these `curl` commands. To
    check whether this number has changed:

    ```
    curl -X POST http://127.0.0.1:45679/relay/list
    ```

    This will list all of the device numbers for that USB port. There should
    only be one device listed which will be the USB relay.
