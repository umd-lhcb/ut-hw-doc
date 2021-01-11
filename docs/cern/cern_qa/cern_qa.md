## DCB CERN QA

!!! note
    All these procedures will be automated by a single WinCC OA panel, which is
    still in th work.

1. Run regular GBTx PRBS test for 2 min.
2. If there's any PRBS error in the previous step, re-run PRBS with 6 mA bias current for 2 min.
3. Run SALT PRBS on available elinks[^1] for 2 min.
4. Read master GBTx status via optical link to master is configurable via optical link.
5. Read selected thermistors on DCB and Stave


[^1]: Some of the hybrids in the slice test Stave are not working, so we can't
      fully test every elink on DCBs.


## LVR CERN QA

!!! note
    All these procedures will be automated by a single WinCC OA panel, which is
    still in th work.

1. Read all output voltages without sense line.
2. Turn on and off each channel.
