## Load a firmware file
This is temporary, as MiniDAQ will reprogram itself with the firmware stored on the on-board flash memory.

To load a firmware:
```
pcie40_pgm ~/src/sof_files/lhcb_daq_firmware_readout40_pcie40v1_minidaq_forUT_unset_131119.sof
```

In our MiniDAQ server, all `sof` firmware are located in:
```
$HOME/src/sof_files
```


## Reprogram the on-board flash memory
This is the firmware that will be loaded by default on each fresh power-on. To do so:
```
pcie40_pgm <path_to_pof_file>
```

Note that here we need a `pof` file, not a `sof` file. Currently, we have some `pof` files in:
```
/opt/lhcb/daq40/firmware
```

## Configure MiniDAQ control software

After programming the MiniDAQ FPGA, **reboot** (not power cycle) the server, and follow these steps:

1. Open a terminal, type in:
    ```
    config_fPLL.py
    ```
2. From the top menu, click **JCOP Framework**, then **Device Editor and Navigator**, then **FSM**.
   Now expand **dist_1**, then right click on **MiniDAQ** to open the **TOP** panel.
3. Click the MiniDAQ state (it now should be **Not Configured**), then click **Configure**.
4. If not all devices showing as **Ready** (excluding **DATAFLOW**), repeat 2-3.

## nanoDAQ

A series of command-line scripts have been implemented in [nanoDAQ](https://github.com/umd-lhcb/nanoDAQ).
The commands are explained in the [nanoDAQ wiki](https://github.com/umd-lhcb/nanoDAQ/blob/master/README.md).