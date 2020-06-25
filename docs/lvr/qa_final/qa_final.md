# Post-Burnin QA Proceedure

!!! info "THIS IS A PLACEHOLDER"
    This is currently a living document to sketch out my ideas and is **NOT** final.
    
Outline of what needs to be accomplished in this QA stage:

1) Secure LVR into cooling setup
    * Connect LVR Analog BB and SPI from Raspberry pi for LVR monitor use.
2) Update and/or Verify the FW version 2.03 (SPI WORD2 enough maybe?)
3) (Re)configure control switches for test
    * be careful about master slave
4) Check power-on curve of 1-4
    * while running at load, verify the current sharing of master/slave for each channel
    * TODO: HOW TO VERIFY SENSE? Maybe repeat with/without sense lines?
5) Check power-on of 5-8
    * while running at load, verify the current sharing of master/slave for each channel
    * TODO: HOW TO VERIFY SENSE?
6) Verify that lockout switches are where they should be
7) Disable JTAG
8) Choose and note LVR subtype in database
9) Remove CCMs from empty channels (to be returned to assembly? or kept for spares?)
10) disable empty channel switches
11) done! disconnect and pack up, make sure database is updated
