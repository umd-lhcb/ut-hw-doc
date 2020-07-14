## Stopping the DCB burn-in

Turn off Maraton channels 0, 1, and 12 and verify that all LEDs are off in the bottom SBC.
Directions here: https://github.com/umd-lhcb/ut-hw-doc/blob/master/docs/burnin/burnin_sw_setup.md#scripts-to-run-on-the-raspberry-pi

Turn off channels 1 and 2 of the Rigol power supply.

Disconnect the optical fibers and pull-up harnesses from the DCBs.

One by one, remove the DCBs from the crate, do a brief visual inspection and check their backplane connectors for damage, and put them in ESD bags.

Update the database with burned-in DCBs.

## Starting the DCB burn-in

Take an initial QA-d DCB out of it's ESD bag and do a brief visual inspection, checking the backplane connector for damage.

One by one, plug DCBs into the crate, lifting the power wires out of the way.  Slots 10 and 11 are unused, I recommend starting with Slot 9 on the left when facing the DCB.  As you plug in each DCB, also plug the pull-up harness into the FFC connector of the Master GBTx (third from the top when plugged into the crate).  After connecting each FFC, power on the appropriate Rigol channel and check that the current consumption increases by ~0.15A, then power it off.  If not, re-seat the FFC cable.

After all DCBs are in the crate and the pull-up harnesses are successfully connected, connect the optical fibers to the Master GBTx mezzanines (third from the top when plugged into the crate).  The fiber bundles are labeled 0-4 and 5-9, and the individual fibers are numbered from 1-12 in each bundle.  Start with (1,2) for DCB 0, with 1 on top.  Proceed with (3,4) etc. with the lower odd numbered fiber always on top.  Fibers 11 and 12 are not used, so start over with (1,2) from the second bundle at DCB 5.

Once all fibers are connected, power on Maraton channels 0, 1, and 12 and verify that the LEDs are on in the bottom SBC.
Directions here: https://github.com/umd-lhcb/ut-hw-doc/blob/master/docs/burnin/burnin_sw_setup.md#scripts-to-run-on-the-raspberry-pi

Open PuTTY, click on MiniDAQ, and navigate to the nanoDAQ directory.

Because the DCB programming can be unreliable on the first tries after power-up, I suggest running 

    ./dcbutil.py init ./gbtx_config/slave-Tx-wrong_termination.txt -g 0 

If there is an error, try again a few times.  If programming has been stable you can skip this step.  Once no error is observed you can program all of the data GBTxs with

    ./burnin_init.sh

enable PRBS with

    ./burnin_prbs.sh

and verify that the boards are properly configured with

    ./burnin_read.sh

Check that each GBTx reports '03151515'.  The burn-in is now running.
