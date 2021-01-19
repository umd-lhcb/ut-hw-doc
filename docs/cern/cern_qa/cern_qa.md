## DCB CERN QA

!!! note
    All these procedures will be automated by a single WinCC OA panel, please
    refer to the section below on how to use it.

1. Run regular GBTx PRBS test for 2 min.
2. If there's any PRBS error in the previous step, re-run PRBS with 6 mA[^1]
   bias current for 2 min.
3. Run SALT PRBS on available elinks[^2] for 2 min.
4. Read master GBTx status via optical link to make sure master is configurable
   this way.
5. Read selected thermistors on DCB and Stave.


[^1]: Default bias current is 5 mA.
[^2]: Some of the hybrids in the slice test Stave are not working, so we can't
      fully test every elink on DCBs.


### Use the DCB QA panel.

!!! info
    The panel looks like this:

    ![DCB CERN QA panel](./dcb_cern_qa_panel.png)


1. Open the panel in `gedi`: `Ctrl+O` -> In **File name: **, locate `objects/fwDCB/UT_DCB_CERN_QA.pnl`
2. Run the panel by clicking the **4-th icon** (floppy drive with a green play
   button) on the `gedi` tool bar.
3. Input the serial numbers for the 2 DCBs in the **SN** fields
4. Click **Start test**
5. Wait for it to finish.
6. Take a look at the **Test results** section.

    1. If there's no red fields, then both of the DCBs are OK.
    2. If there's red, document the corresponding DCB as bad
    3. All test results are also saved in a log file.


## LVR CERN QA

!!! note
    All these procedures will be automated by a single WinCC OA panel, which is
    still in th work.

1. Read all output voltages without sense line.
2. Turn on and off each channel.
