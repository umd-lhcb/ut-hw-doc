If you are already familiar with this procedure, you can simply follow the [LVR initial QA checklist](LVR_initial_QA_checklist.pdf).

!!! info "Before you proceed"

    - Beware that **`TP5`** is **NOT** GND. The silkscreen label applies to
      the adjacent **`TP2`**.

    - Caution is needed when connecting test lead clips to the
      test points. The test points are rather fragile and easily pulled of the board.

    - Care must be taken to avoid temporary unintended shorts from the high
      density of surrounding components, vias, and traces.

1. Visually inspect a new LVR and **set the switches** as indicated in the table below.
Order refers to toggles 1234 on the switch, with `1` meaning `ON`. (CCM) or (FPGA) refer to the side
of the LVR the switch is on. There are four SW6 switches.
    ![](table_switches.png)
  
2. Place the LVR on the holder as shown in the picture. The CCM side should be facing you and the input
connector be at the top. Recall that the one input is on one end and the two outputs on the other.
  ![](lvr_setup_board.jpg)
  
3. Place an serial number sticker on a new LVR under the input connector, and document its serial number in the
[database](https://docs.google.com/spreadsheets/d/1KjXGhOFzi0SZPsozpKzxGjVtfr4kkS_Hv5EigUwKOj8/edit#gid=1564410083).
Also document which type of LVR you intend to QA (12MS, 12A, 12MSA, 15MS, 25A). 

    - You don't need to fill every column in the database as you complete that test until you finish the QA
    or leave the setup for any reason.
    - The CCM serial number is documented at a later stage, during LVR assembly.

4. Verify that the chassis and power ground are isolated by \> 25k Ohms (often 180k Ohms)
    1. Measure the resistance between the lugs sticking out near the input connector and any `GND` test point
    on the board (eg. **`TP7`**)
    2. Repeat measurement reversing the polarity of leads (ground isolation circuit is different each way)

5. Connect JTAG programmer to **`J17`** on the back of the board, bottom-center (the ribbon in the picture
    abvove). Connect blue jumpers between **`J22`** (near ch8) pins 2 & 4 (`V_pump`) and between `J22` pins 1 & 3 (`V_jtag`).
You can zoom in the above picture (righ-click, view image) to check it. This
configuration allows you to program the FPGA later on.

6. Connect the raspberry Pi LVR monitor to the board, and activate the LVR monitor on the laptop if it is
not already running. If not using the Pi, you can follow the instructions at the bottom of the page.
    1. Go to PuTTY and select Monitor Pi
    2. Both user name and password are "`lvr`"

7. Set the power supply initially to 1.6V and the current limited to 2.0A, and connect provided input breakout board.
Verify polarity of connections visually
    1. Red wire in positive terminal of power supply
    2. Blue wire in negative terminal
    3. Negative terminal ground shorted
    4. Turn power supply on and enable output

8. Adjust the `P1`, `P2`, and `P5` potentiometers so that the 1.5V, 3.3V, and 5.5V rails (voltage plateaus) are
set to those values.
    1. Slowly increase the input voltage from the initial 1.6V until either the 1.5V reading (`Vin_FPGA_1V5`) stops increasing or
    exceeds 1.5V. At this point, tune the output using P1 to set it to 1.5V. You may have to increase the voltage
    more and iterate the tuning process. An alternate approach is given in the tip below.
    
    2. Resume raising the input voltage and repeat this process on the 3.3V (`Vin_FPGA_3V3`) and 5.5V (`V_OPAMP_RAIL`) 
    levels in the Pi LVR monitor. You should now be able to raise the input voltage all the way to 7V and the three readings
    should be stable.
    
    !!! warning
        **STOP IF VALUES BELOW ARE EXCEEDED** to prevent damage.

        - 1.5V x 110% = 1.65V
        - 3.3V x 110% = 3.63V
        - **The 5.5V rail (`Vop_rail`) should not exceed 5.5V!!**
        
        When the power supply reaches about 4.5V, the expected input current given by the supply at this point
        should be around 0.09A. If it is substantially more there may be a problem

    !!! tip    
        It may be useful to let the rail approach the desired value from below as input voltage increases,
        then turn down the rail plateau to a value below the desired final plateau, and make the final
        adjustments by turning the input voltage and rail plateau values up simultaneously. Note that you can
        verify the rail has reached its plateau if you increase the input voltage and the rail voltage no
        longer increases.

    !!! info "Desired values"
        - The 1.5V and 3.3V rails should be set to within 0.01V if possible.
        - The 5.5V rail works in the 5.0-5.5V range, with a
        preference to be in the range 5.45-5.5V, as this allows for a slightly better time response.

9. Adjust the `P3` and `P4` potentiometers to set utput standby configuration. Adjust the voltage offsets to
1.483V (1.2V LVR), 1.546V (1.5V LVR), or 1.775V (2.5V LVR) within a few mV at the
    following test point pairs using the following potentiometers, using a multimeter to read the DC voltage.

    - CH 4-1: **`TP9`** (`Vos_gen`) and **`TP10`** (GND)
    - CH 8-5: **`TP14`** (`Vos_gen`) and **`TP15`** (GND)


10. Program the FPGA
    1. Initiate the program sequence, opening FlashPro on the laptop if is not already running
        1. If no program has been loaded onto the FPGA, go to Open Project and select the pre-loaded
        program in the LVR folder you want to run
        2. Go to Configure Device
        3. Click Browse, and select the file v2-06_lvr_fw.stp
        4. Set **MODE** to basic (should be default), and set **ACTION** to program
        5. Once that is complete, click **PROGRAM**
    2. Check in the log that the auto-verify ran successfully (`RUN PASSED` in green).

11. Turn off power and install all 8 CCMs in the orientation that allows you to read the silkscreen as shown below.
Remove the Raspberry Pi connector to install those.
  ![](ccm_board.jpg){: style="height:200px"}
    - For an `MS` type LVR, set up master CCMs on odd channels, slaves on even.
    - For an `A` type LVR, place stand-alone single master (`A`) CCMs on all channels.
    - For `MSA` type, fill channels 1-4 with `MS` and 5-8 with `A` CCMs.


12. Reduce power supply voltage to about 4.3V (1.2V LVR), 4.8V (1.5V LVR), or 5.3V (2.5V LVR) and check the **under-voltage lockout (UVL) turns all channels off**
in the Rpi monitor.
    - Set input voltage back to 7V
    
13. Change SW1 to `0011`, and check the **over-temperature protection turns all channels off** and the `LD7` LED turns on. Some times you may have to go all the way to `1111`.

12. Use the RJ45 breakout board to perform the sense line test.
    Verify that the voltage of a channel goes to RAIL when the corresponding sense
    lines are shorted to each other selecting the appropriate switches

    !!! note
        Slave channels will not alter voltage when shorting those channels.
        They will only go to RAIL when shorting their respective master channels.
    ![](sense_line_board.jpg){: style="height:300px"}

13. SPI Communication test
    1. On the laptop's desktop, locate the "SPI test". Run this shortcut. The username and password are both 'spitest'
    2. Request WORD2, which should end with 0x206 (the FW version) and try modifying the config to turn all the channels OFF and ON again.
    4. Connect the SPI_RESET line (floating green wire) to any GND test point on the LVR and check that the response is all `00 00 00 00`
    no matter the command you send until you allow the SPI_RESET to float once more.

14. Switch off the power and disconnect everything from the board (excluding the jumpers placed on **`J22`**),
and place colored stickers on the board near the CCM connectors to indicate which CCMs were used on the board
during the QA.

15. Make sure you update the
[database](https://docs.google.com/spreadsheets/d/1KjXGhOFzi0SZPsozpKzxGjVtfr4kkS_Hv5EigUwKOj8/edit#gid=1564410083)
appropriately. **You're done!**


### If not using the raspberry Pi LVR monitor
Place a DVM (DC Voltage Meter) between **`TP3`**
(3.3V) and **`TP6`** (GND) to monitor the 3.3V rail, another DVM between **`TP8`** (1.5V) and **`TP6`**
(GND) to monitor the 1.5V rail, and a third DVM between **`TP4`** (`Vop_rail`) and **`TP7`** (GND) to
monitor the op amp rail. The first image below shows the location of **`TP3`**, **`TP6`**, and **`TP8`**,
as well as potentiometers **`P1`** and **`P2`** that will be used to adjust the 1.5V and 3.3V rails. The
second image shows the locations of **`TP4`**, **`TP7`**, and **`P5`** for the op amp rail.

![](lvr_qa1.png)

![](lvr_qa2.png)

