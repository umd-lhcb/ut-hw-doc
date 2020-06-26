!!! note
    The MiniDAQ configuration steps are only needed after a power cycle or
    power outage.

## Load a firmware file
This is temporary, as MiniDAQ will reprogram itself with the firmware stored on the on-board flash memory.

To load a firmware:
```
pcie40_pgm ~/src/sof_files/lhcb_daq_firmware_readout40_pcie40v1_minidaq_forUT_Bologna+realsim_12+12links_unset_090620.sof
```

In our MiniDAQ server, all `sof` firmware are located in:
```
$HOME/src/sof_files
```


## Configure MiniDAQ control software

After programming the MiniDAQ FPGA, **restart** (not power cycle) the server, and follow these steps:

1. Open a terminal, type in:

        pcie40_reload -m
        config_fPLL.py

2. Start the Project by going to going to **Applications, WinCC, Project Administrator**.

2. From the top menu, click **JCOP Framework**, then **Device Editor and Navigator**, then **FSM**.
   Now expand **dist_1**, then right click on **MiniDAQ** to open the **TOP** panel.
3. Take the MiniDAQ. Click the MiniDAQ state (it now should be **Not Configured**), then click **Configure**.
4. If not all devices showing as **Ready** (excluding **DATAFLOW**), repeat 2-3.


## Connect to MiniDAQ screen remotely

If you are in UMD network, use a VNC client and the address are:
```
<minidaq_ip_addr>:5900
```

If you are outside, first create a SSH tunnel to map MiniDAQ port 5900 to one
of your localhost port (5901 in the example):
```
SSH -L 5901:localhost:5900 <user>@<minidaq_ip_addr>
```

Then use the local port for your VNC session:
```
localhost:5901
```

!!! note
    The additional password for the VNC connection is printed on the sticker of
    the **Windows PC**.

!!! info
    If you are a Linux user, install `tigervnc` and follow the standard
    literature on the Internet on how to use it.

    If you are a macOS user, use the mighty built-in VNC viewer from cli:

        open vnc://<ip_addr>:<port>


## nanoDAQ

A series of command-line scripts have been implemented in [nanoDAQ](https://github.com/umd-lhcb/nanoDAQ).
The commands are explained in the [nanoDAQ wiki](https://github.com/umd-lhcb/nanoDAQ/blob/master/README.md).


## Configure a MiniDAQ from scratch

Please refer to [this guide](https://github.com/umd-lhcb/MiniDAQ-config) on how to configure a MiniDAQ from scratch.
