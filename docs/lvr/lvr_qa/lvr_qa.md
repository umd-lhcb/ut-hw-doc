## Before you proceed

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

3. Activate the LVR monitor
    1. Go to PuTTY and select Monitor Pi
    2. Both user name and password are "`lvr`"

4. Set power supply initially to 1.6V and the current limited to 1.5A

5. Connect up power with any number of channels (ideally since all
   channels are being tested you should put fuses in all slots, however
   in principal it does not matter which channel you select)
    1. Verify voltage polarity of connections

6. Place a DVM (DC Voltage Meter) between **`TP3`** (3.3V) and **`TP6`** (GND)
   to monitor the 3.3V rail

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

9. Adjust P1 to obtain 1.5V  on **`TP8`**.

10. Adjust P2 to obtain 3.3V on **`TP3`**.

11. Re-verify both the 3.3V and 1.5V rails are correct. σV should be
    at most 0.01 V.

12. Record input current.

13. Place a DVM between **`TP4`** (`Vop_rail`) and **`TP7`** (GND)

    ![](lvr_qa1.png)

14. Slowly increase the input voltage to 7V until EITHER the Vop\_rail
    stops increasing or hits 5.5V.


    1. Adjust P5 whilst increasing the input voltage
    2. The `Vop_rail` will clamp at a maximum of 5.5V when properly
        adjusted.

    ![](lvr_qa2.png)

    !!! warning
        **IT IS IMPERATIVE THAT THE `Vop_rail` NOT EXCEED 5.5V !!!!**

    !!! note
        You can also use the monitor to view Op Rail voltage (denoted as
        `V_OPAMP_RAIL`).

15. Program the FPGA
    1. Turn power off
    2. Connect jumpers between **`J22`** pins 2 & 4 (`V_pump`) and between
       `J22` pins 1 & 3 (`V_jtag`).
    3. Connect programmer to **`J17`**.
    4. Turn power on

    5. Initiate the program sequence
        1. If no program has been loaded onto the FPGA, go to Open Project
        2. Inside the LVR folder select the program you want to run
        3. Go to Configure Device
        4. Click Browse, and select the `.pdb` file you wish to use to
           program
        5. Set **MODE** to basic, and set **ACTION** to program
        6. Once that is complete, click **PROGRAM**

    6. Record checksum when program is done

        !!! note
            Checksum should be a 7-digit number: Checksum = `_______`

    7. Move jumpers on **`J22`** to connect pins 4 & 6 and pins 3 & 5



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
       duty cycle, set SW3 pin 1 to **OFF**, otherwise keep pin at **ON**

        ![](lvr_qa5.png)

17. Undervoltage Lockout test
    1. Set input power to ~4.8 V
    2. Locate SW6\[A, B, C, D\]. The switcher-channel correspondence is the
       following:

        | SW6 switcher | Channels |
        |--------------|----------|
        | SW6A         | CH7 & 8  |
        | SW6B         | CH5 & 6  |
        | SW6C         | CH3 & 4  |
        | SW6D         | CH1 & 2  |

    3. For each SW6\#, verify that its corresponding channels shut off
       when turning the switch configuration to \[**OFF, OFF, OFF, OFF**\]
    4. Each channel should switch from some voltage (depending on power
       supply setting) to ~0V.

18. Overtemperature lockout test
    1. Locate SW1.
    2. Set SW1 to \[**ON, ON, ON, ON**\].

        !!! note
            This tells the board to lockout at room temperature.

    3. Locate **`LD7`** (bottom left corner of LVR).
    4. Verify **`LD7`** is `ON`.
    5. Verify all `V_OUT` channel values as shown on monitor go to ~0V.

19. Output standby configuration. Adjust the Voltage offsets at the
    following test point pairs using the following variable resistors

    - CH 4-1: **`TP9`** (`Vos_gen`) and **`TP10`** (GND)
    - CH 8-5: **`TP14`** (`Vos_gen`) and **`TP15`** (GND)

    Adjust P3 and P4 on each respective side of the board in order
    to configure the voltages.

    !!! note
        Each 4-channel group must be set to operate with the same output
        voltage as shown below:

        | Vos [V] | Vout [V] |
        |---------|----------|
        | 1.775   | 2.5      |
        | 1.546   | 1.5      |
        | 1.483   | 1.225    |

20. Use the RJ45 breakout board to perform the sense line test
    Verify that the peak voltage goes to RAIL when the following sense
    lines are shorted to each other. Recall that on the respective
    ethernet connectors:

    | Channels | Pins  |
    |----------|-------|
    | CH1 & 5  | 1 & 2 |
    | CH2 & 6  | 4 & 5 |
    | CH3 & 7  | 3 & 6 |
    | CH4 & 8  | 7 & 8 |


    !!! note
        Slave channels will not alter voltage when shorting those channels.
        They will only go to RAIL when shorting their respective master channels.

21. Set SW2 1^st^ switch to **ON** (takes regulator out of pulsed mode).
