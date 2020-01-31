LVR QA Procedure
================

Note the following before beginning QA procedures:

a)  Beware that TP5 is ***not*** GND. The silkscreen label applies to
    the adjacent TP2.

b)  Fused power input breakout board silk screen circuit labels are
    incorrect.

c)  The LVR outputs should be connected to a benign load that can
    withstand having upwards of 7v output. (ie the LVR channel outputs
    follow the input power rail if the CCM is not populated and
    configured.)

d)  Extreme caution is needed when connecting test lead clips to the
    test points.

    a.  The test points are rather fragile and easily pulled of the
        board.

    b.  Care must be taken to avoid temporary unintended shorts from the
        high density of surrounding components, via's, and traces.

e)  When configuring the CCMs on the LVR, remember that CCM voltage
    types split down the middle of the LVR (i.e. CH1-4 must have the
    same CCM voltage, CH5-8 must have the same CCM voltage)

f)  Going down the board on one side, arrange CCMs as master, slave,
    master, slave, etc.

g)  The Master-Slave configurations require a jumper ON the LVR output
    breakout board that electrically connects the master and slave
    output rails together.

Full QA Procedure:

1)  Note Serial Number of LVR and CCM before beginning QA

2)  Verify that the chassis and power ground are isolated \> 25K Ohms.

    a.  Measure input voltage at the large lugs at the top of the board

    b.  Use any GND TP on the board (i.e. TP7)

3)  Activate the LVR monitor

    a.  Go to PuTTY and select Monitor Pi

    b.  Password is lvr

4)  Set power supply initially to 1.6 V and the current limited to 1.5 A

5)  Connect up power with any number of channels (ideally since all
    channels are being tested you should put fuses in all slots, however
    in principal it does not matter which channel you select)

    a.  Verify voltage polarity of connections

6)  Place a DVM (DC Voltage Meter) between TP3 (3.3V) and TP6 (GND) to
    monitor the 3.3v rail

7)  Place another DVM between TP8 (1.5V) and TP6 (GND) to monitor the
    1.5v rail

> **Note you can also use the LVR monitor for this section, looking at
> the Vin\_FPGA\_3V3 and Vin\_FPGA\_1V5 readings**

8)  Slowly increase the input voltage from the initial 1.6V to a max of
    4.5V while monitoring the 3.3v and 1.5v rails to make sure they stay
    below the max values. STOP IF VALUES BELOW ARE EXCEEDED to prevent
    damage.

    a.  1.5V x 110% = 1.65V

    b.  3.3V x 110% = 3.63V

9)  Adjust p1 to obtain 1.50 v on TP8.

10) Adjust p2 to obtain 3.3v on TP3.

11) Re-verify both the 3.3v and 1.5v rails are correct. σ~V~ should be
    at most 0.01 V.

12) Record input current

![](lvrqa1.png)

13) Place a DVM between TP4 (Vop\_rail) and TP7 (GND)

14) Slowly increase the input voltage to 7V until EITHER the Vop\_rail
    stops increasing or hits 5.5V.

    a.  **IT IS IMPERATIVE THAT THE Vop\_rail NOT EXCEED 5.5V !!!!**

    b.  Adjust P5 whilst increasing the input voltage

    c.  The Vop\_rail will clamp at a maximum of 5.5V when properly
        adjusted.
![](lvrqa2.png)
**Note you can also use the monitor to view Op Rail voltage (denoted as
V\_OPAMP\_RAIL)**

15) PROGRAM THE FPGA

```{=html}
<!-- -->
```
a.  Turn power off

b.  Connect jumpers between J22 pins 2 & 4 (V\_pump) and between J22
    pins 1 & 3 (V\_jtag)

c.  Connect programmer to J17.

d.  Turn power on

e.  Initiate the program sequence

    i.  If no program has been loaded onto the FPGA, go to Open Project

    ii. Inside the LVR folder select the program you want to run

    iii. Go to Configure Device

    iv. Click Browse, and select the .pdb file you wish to use to
        program

    v.  Set MODE to basic, and set ACTION to program

    vi. Once that is complete, click PROGRAM

f.  Record checksum when program is done

    i.  Checksum = \_\_\_\_\_\_\_

g.  Move jumpers on J22 to connect pins 4&6 and pins 3&5



16) Set dip switch configuration for undervoltage lockout and overtemp
    lockout

    a.  Locate dip switches SW6\[A,B,C,D\]. Note the side of the switch
        body labeled ON.

        i.  Set the 3^rd^ switch to ON. Leave others OFF

    b.  Locate the switch labeled SW1

        i.  Set the 4^th^ switch to ON. Leave others OFF

    c.  Locate the switches on the back of the regulator (SW2-5)

        i.  Set SW5 to \[OFF, OFF, OFF, OFF\]

        ii. For SW4, for each channel pair that has a master-slave pair,
            set each corresponding pin to OFF if a slave is present in
            the channel pair, otherwise set to ON

            1.  1 -\> CH1+2, 2 -\> CH3+4, 3 -\> CH5+6, 4 -\> CH7+8

        iii. Set SW2 and 3 to \[OFF, OFF, OFF, OFF\]

    d.  Note that the ON position is labelled opposite the numbered
        slots (1, 2, 3, 4)

    e.  Additionally, note that if you wish the board to be in pulsed
        duty cycle, set SW3 pin 1 to OFF, otherwise keep pin at ON

![](lvrqa3.png)
![](lvrqa4.png)
![](lvrqa5.png)

17) Undervoltage Lockout test

    a.  Set input power to \~4.8 V

    ```{=html}
    <!-- -->
    ```
    a.  Locate SW6\[A, B, C, D\]

        i.  SW6A -\> CH7 + CH8

        ii. SW6B -\> CH5 + CH6

        iii. SW6C -\> CH3 + CH4

        iv. SW6D -\> CH1 + CH2

    b.  For each SW6\#, verify that its corresponding channels shut off
        when turning the switch configuration to \[OFF, OFF, OFF, OFF\]

    c.  Each channel should switch from some voltage (depending on power
        supply setting) to \~0V

18) Overtemperature lockout test

```{=html}
<!-- -->
```
a.  Locate SW1

b.  Set SW1 to \[ON, ON, ON, ON\]

    i.  This tells the board to lockout at room temperature

c.  Locate LD7 (bottom left corner of LVR)

d.  Verify LD7 is ON

e.  Verify all V\_OUT channel values as shown on monitor go to \~0V

```{=html}
<!-- -->
```
19) Output standby configuration. Adjust the Voltage offsets at the
    following TP pairs using the following variable resistors

    a.  CH 4 to 1: TP9 (Vos\_gen) and TP10(GND)

    b.  CH 8 to 5: TP14 (Vos\_gen) and TP15(GND)

    c.  Adjust P3 and P4 on each respective side of the board in order
        to configure the voltages.

```{=html}
<!-- -->
```
i.  EACH 4-channel group must be set to operate with the same output
    voltage as shown below:

> Vos Vout

-   1.775V 2.5V case

-   1.546V 1.5V case

-   1.483V 1.225V case

20) Use the RJ45 breakout board to perform the sense line test

```{=html}
<!-- -->
```
a.  Verify that the peak voltage goes to RAIL when the following sense
    lines are shorted to each other. Recall that on the respective
    ethernet connectors:

    i.  CH1 & CH5 are pins 1&2,

    ii. CH2 & CH6 are pins 4&5

    iii. CH3 & CH7 are pins 3&6

    iv. CH4 & CH8 are pins 7&8

    ```{=html}
    <!-- -->
    ```
    a.  Note that slave channels will not alter voltage when shorting
        those channels. They will only go to RAIL when shorting their
        respective master channels.

```{=html}
<!-- -->
```
21) Set SW2 1^st^ switch to ON (takes regulator out of pulsed mode)
