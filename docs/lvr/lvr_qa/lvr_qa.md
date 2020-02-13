!!! info 
    ***Before you proceed***

    - Beware that **`TP5`** is **NOT** GND. The silkscreen label applies to
      the adjacent **`TP2`**.

    - Fused power input breakout board silk screen circuit labels are
      incorrect.

    - The LVR outputs should be connected to a benign load that can withstand
      having upwards of 7V output. (i.e. the LVR channel outputs follow the input
      power rail if the CCM is not populated and configured.)

    - Extreme caution is needed when connecting test lead clips to the
      test points.

    - The test points are rather fragile and easily pulled of the board.

    - Care must be taken to avoid temporary unintended shorts from the high
      density of surrounding components, via's, and traces.

    - When configuring the CCMs on the LVR, remember that CCM voltage
      types split down the middle of the LVR (i.e. CH1-4 must have the same CCM
      voltage, CH5-8 must have the same CCM voltage)

    - Going down the board on one side, arrange CCMs as master, slave, master,
      slave, etc.

    - The Master-Slave configurations require a jumper ON the LVR output breakout
      board that electrically connects the master and slave output rails together.
    

## Full QA Procedure

1. Note Serial Number of LVR and CCM before beginning QA

2. Verify that the chassis and power ground are isolated \> 25K Ohms.
    1. Measure input voltage at the large lugs at the top of the board
    2. Use any GND test point on the board (i.e. **`TP7`**)
    3. Repeat measurement reversing the polarity of leads (ground isolation circuit is different each way)

3. Activate the LVR monitor if it is not already running
    1. Go to PuTTY and select Monitor Pi
    2. Both user name and password are "`lvr`"

4. Set power supply initially to 1.6V and the current limited to 2.0A

5. Connect provided input breakout board. Verify polarity of connections visually
    1. Red wire in positive terminal of power supply
    2. Blue wire in negative terminal
    3. Negative terminal and power supply ground shorted

6. If not using the raspberry pi LVR monitor, place a DVM (DC Voltage Meter) between **`TP3`** (3.3V) and **`TP6`** (GND)
   to monitor the 3.3V rail, otherwise proceed to step 8.

7. Place another DVM between **`TP8`** (1.5V) and **`TP6`** (GND) to monitor
   the 1.5N rail

    !!! note
        You can also use the LVR monitor for this section, looking at
        the `Vin_FPGA_3V3` and `Vin_FPGA_1V5` reading.

8. Slowly increase the input voltage from the initial 1.6V to a max of
   4.5V while monitoring the 3.3V and 1.5V rails to make sure they stay
   below the max values.

    !!! warning
        **STOP IF VALUES BELOW ARE EXCEEDED** to prevent damage.

        - 1.5V x 110% = 1.65V
        - 3.3V x 110% = 3.63V
        
    !!! tip
        It may be useful to let the rail approach the desired value, then turn down
        the setpoint to a value much below the current input voltage in order to find
        the plateau (max voltage where the rail 'sticks') more quickly

9. Adjust P1 to obtain 1.5V  on **`TP8`**.

10. Continue increasing the input voltage and similarly adjust P2 to obtain 3.3V on **`TP3`**.

11. Both the 3.3V and 1.5V rails should be correct now and no longer 
    increase as input voltage goes up. σV should be 0.01 V or less if possible.

12. Expected input current given by the supply at this point should be around 0.09A.
    If it is substantially more there may be an issue.

13. If not using the LVR monitor, place a DVM between **`TP4`** (`Vop_rail`) and **`TP7`** (GND).
    Otherwise proceed.

    ![](lvr_qa1.png)

14. Slowly increase the input voltage to 7V until EITHER the Vop\_rail
    stops increasing or hits 5.5V. (Note this is just the same thing as
    for the 1.5V and 3.3V, just now it's 5.5V).


    1. Adjust P5 whilst increasing the input voltage
    2. The `Vop_rail` will clamp at a maximum of 5.5V when properly
        adjusted.

    ![](lvr_qa2.png)

    !!! warning
        **IT IS IMPERATIVE THAT THE `Vop_rail` NOT EXCEED 5.5V !!!!**

    !!! tip
        In the LVR monitor software this voltage rail is denoted as
        `V_OPAMP_RAIL`, because this is the input voltage used to power
        OpAmps (operational amplifiers) on the board and ccms.

15. Program the FPGA
    1. Turn power off
    2. Connect jumpers between **`J22`** (near ch8) 
        pins 2 & 4 (`V_pump`) and between
       `J22` pins 1 & 3 (`V_jtag`).
    3. Connect programmer to **`J17`** (back of the board, center).
    4. Turn power on

    5. Initiate the program sequence
        1. If no program has been loaded onto the FPGA, go to Open Project, otherwise continue to 5.
        2. Inside the LVR folder select the program you want to run
        3. Go to Configure Device
        4. Click Browse, and select the `.pdb` file you wish to use to
           program
        5. Set **MODE** to basic (should be default), and set **ACTION** to program 
        6. Once that is complete, click **PROGRAM**

    6. Check in the log that the auto-verify ran successfully. 

    7. Turn off power and install CCMs


16. Set dip switch configuration for undervoltage lockout and overtemp
    lockout
    1. Locate dip switches SW6\[A,B,C,D\]. Note the side of the switch
       body labeled ON.
       Set the 3^rd^ switch to **ON**. Leave others **OFF**.

        ![](lvr_qa3.png)

    2. Locate the switch labeled SW1. Set the 4^th^ switch to **ON**. Leave
       others **OFF**.

    3. Locate the switches on the back of the regulator (SW2-5)

        ![](lvr_qa4.png)

        1. Set SW5 to \[**OFF, OFF, OFF, OFF**\]
        2. For SW4, for each channel pair that has a master-slave pair,
           set each corresponding pin to **OFF** if a slave is present in
           the channel pair, otherwise set to **ON**

            | SW4 switcher | Channels |
            |--------------|----------|
            | 1            | CH1 & 2  |
            | 2            | CH3 & 4  |
            | 3            | CH5 & 6  |
            | 4            | CH7 & 8  |

        3. Set SW2 and SW3 to \[**OFF, OFF, OFF, OFF**\]


    4. Note that the ON position is labelled opposite the numbered
       slots (1, 2, 3, 4)

    5. Additionally, note that if you wish the board to be in pulsed
       duty cycle, set SW3 pin 1 to **OFF**, otherwise keep pin at **ON**.
       For most of the QA sequence it will be more useful in **ON**

        ![](lvr_qa5.png)

17. Undervoltage Lockout test
    1. Set input power to ~4.8 V
    2. Reduce the input power gradually, and confirm that the outputs shut off below
       4.5-4.6 volts (ish).
    
    !!! info
        To test individual undervoltage lockouts (if needed) use the following procedure

        1. Locate SW6\[A, B, C, D\]. The switcher-channel correspondence is given in the table below

        2. For each SW6\#, verify that its corresponding channels shut off
           when turning the switch configuration to \[**OFF, OFF, OFF, OFF**\]

        3. Each channel should switch from some voltage (depending on power
           supply setting) to ~0V.

        | SW6 switcher | Channels |
        |--------------|----------|
        | SW6A         | CH7 & 8  |
        | SW6B         | CH5 & 6  |
        | SW6C         | CH3 & 4  |
        | SW6D         | CH1 & 2  |

18. Overtemperature lockout test
    1. Locate SW1.
    2. Set SW1 to \[**ON, ON, ON, ON**\].

        !!! info
            This tells the board that it should shut down if it gets above ~ 20C (room temperature).

    3. Locate **`LD7`** (bottom left corner of LVR).
    4. Verify **`LD7`** is `ON`.
    5. Verify all `V_OUT` channel values as shown on monitor go to ~0V.
    6. Set SW1 back to nominal \[**OFF, OFF, OFF, ON**\]

19. Output standby configuration. Adjust the Voltage offsets at the
    following test point pairs using the following variable resistors

    - CH 4-1: **`TP9`** (`Vos_gen`) and **`TP10`** (GND)
    - CH 8-5: **`TP14`** (`Vos_gen`) and **`TP15`** (GND)

    Adjust P3 and P4 on each respective side of the board in order
    to configure the voltages. (They are beside the testpoints. You can remove
    the nearby CCM if it gets in your way)

    !!! note
        Each 4-channel group must be set to operate with the same output
        voltage according to what kind of CCM it will host as shown below:

        | Vos [V] | Vccm [V] |
        |---------|----------|
        | 1.775   | 2.5      |
        | 1.546   | 1.5      |
        | 1.483   | 1.225    |

20. Use the RJ45 breakout board to perform the sense line test.
    Verify that the voltage of a channel goes to RAIL when the corresponding sense
    lines are shorted to each other. The sense lines are mapped to the RJ45 as follows:

    | Channels         | Pins  | RJ45 Connector |
    |------------------|-------|----------------|
    | CH1              | 1 & 2 | Right (J10)    |
    | CH2 (if 12/25A)  | 4 & 5 | Right (J10)    |
    | CH3              | 3 & 6 | Right (J10)    |
    | CH4 (if 12/25A)  | 7 & 8 | Right (J10)    |
    | CH5              | 1 & 2 | Left  (J16)    |
    | CH6 (if 12/25A)  | 4 & 5 | Left  (J16)    |
    | CH7              | 3 & 6 | Left  (J16)    |
    | CH8 (if 12/25A)  | 7 & 8 | Left  (J16)    |


    !!! note
        Slave channels will not alter voltage when shorting those channels.
        They will only go to RAIL when shorting their respective master channels.
        
21. Aux current follower test
    1. Plug the provided load board (output breakout board with 4 resistors) onto one of the
       LVR output connectors. You should see the current output on that channel go up to a few 100s of mA
    2. For each channel on the half of the board corresponding to the output connector you have the load in,
       confirm that the voltage drop across R73 and R81 are the same to within a few %. These are the two 
       medium-sized resistors
       with R050 and R150 printed on them.
    3. Rinse and repeat on other half of LVR.
    
    !!! note
        for this test we do want both master and slave channels to be checked. 
       
22. SPI Communication test
    1. On the laptop's desktop, locate the "SPI test". Run this shortcut.
    2. The username and password are both 'spitest'
    3. The 4 bytes transmitted to the LVR are in the left column, the 4 received are on the right. You should
       see (possibly after 4-5 rounds of communication) that the message received from the LVR is the previous one that
       was sent.
       
    !!! example
        The following illustrates the kind of output you're looking for:

            04 04 04 04       03 03 03 03
            05 05 05 05       04 04 04 04
            06 06 06 06       05 05 05 05
            07 07 07 07       06 06 06 06
    

21. If it is not already, set SW2 1^st^ switch to **ON** (takes regulator out of pulsed mode).
