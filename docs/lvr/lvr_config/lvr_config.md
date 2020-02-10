## Abstract

The following serves as a guide for general LVR operation as well as LVR
QA procedures. The firmware loaded onto the LVRs by default does not
allow for channels to be directly controlled. When power is connected
the channels will come up in sequenced pairs (1-2, then 3-4, etc). It is
therefore important that you only bring up Vin if you are okay with
there being Vout. It is wise to first power up with the loads
disconnected and verify the polarity and amplitude of the outputs.
Beware doing this that if loads are disconnected from Vout but the sense
lines remain hooked up the output will just jump to 5V.

Channels should not be left at 5V output for a long time. There is a
resistor providing 220 Ohm minimal load, which is rated for 0.125W, but
would have to dissipate 0.11W. Therefore, channels with power but no CCM
should be set up as per "other unused channels" below, such that the
power through this resistor is negligible.


## Channel Sense lines

If RJ45 connections to the remote sense are unavailable (broken) the
regulators will fall back on a local sense mode and regulate the output
voltage at their connector instead. The sense line inputs follow RJ45
conventions:

| Channels | Pins  |
|----------|-------|
| CH1 & 5  | 1 & 2 |
| CH2 & 6  | 4 & 5 |
| CH3 & 7  | 4 & 5 |
| CH4 & 8  | 7 & 8 |


## Setting Up Monitor/Programmer

This section deal with setting up the monitor/programmer for the LVR.

To set up the programmer:

1. Turn power off
2. Connect jumpers between **`J22`** pins 2 & 4 (`V_pump`)
3. Connect jumpers between **`J22`** pins 1 & 3 (`V_jtag`)
4. Connect programmer to **`J17`**.
5. Turn power on
6. Initiate the program sequence
7. Move jumpers on **`J22`** to connect pins 4 & 6 and pins 3 & 5

To set up the monitor:

1. Connect Raspberry Pi leads to **`J18`**.

    !!! note
        Leads must start at pin row 3-4, not 1-2.

2. Turn on raspberry Pi and run code
3. `V_SENSE` refers to the output feedback voltage from the CCM
4. `V_REGUL_OUT` refers to full input voltage
5. `i_SENSE_MON` refers to current through resistor `____`


## Fuse/Channel Configuration

This section deals with which channels are being used. Ideally fuses
should be installed only for the channels to be used. Unfused is the
safest state for an unused channel.

The input BBs are mislabeled:

| Label on fuse | Channels |
|---------------|----------|
| F3-4          | CH5 & 6  |
| F1-2          | CH7 & 8  |
| F7-8          | CH1 & 2  |
| F5-6          | CH3 & 4  |

Input voltage should be set above the UVL (Undervoltage lockout) setting
for that fuse group. As presently configured (pre-slice test) 5.5V
appears adequate for all configurations, but this is subject to further
study

Undervoltage lockout is configured via SW6A-SW6D (that is, one per fuse
group). This circuit disables the associated channels if the input
voltage falls below a threshold set by the switch. Within one SW4x, the
four toggles form a 3-digit number `LSB -> MSB`, with the fourth toggle
putting the channel in an **always on** state (override UVL).

It is best to be at least 0.25V, preferably 0.5V above the actual
drop-out voltage, otherwise a channel may appear to be on, but when it
actually tries to start the natural drop in Vin from the abrupt increase
in current demand by the regulator causes the UVL to trip, leading to a
series of false-start hiccups rather than actual starts.


## Configuration of LVR

LVR Configuration is done via the CCMs and the potentiometers P3 and P4,
which should be set according to the CCMs to be installed as

| Vos [V] | Vout [V] |
|---------|----------|
| 1.775   | 2.5      |
| 1.546   | 1.5      |
| 1.483   | 1.225    |

P3 controls CH1-CH4, P4 controls CH5-CH8, and each group of four must
use the same CCM Vout. Vos may be measured across TP9-TP10 for CH1-4,
and TP14-15 for CH5-8.


## Normal versus Duty Cycle Mode

For Low Duty Cycle Pulsed mode, we enable this via setting SW3-1 to OFF.
It provides a pulse every ~3 seconds that appears to last for ~60ms.
Normal mode (or continuous mode) provides continuous transmission of
voltage.

It is recommended that for operation periods greater than ~20 minutes
to have the board on Duty Cycle Pulsed mode (30-45 min in extreme
cases), whereas short operation periods can utilize continuous mode.
This is to prevent overheating of 4913ADLHC regulator chips on LVR.


## Master/slave pairings

Master slave pairs should ideally always be within a fuse group, and
must follow ascending channel number. That is, CH1 is M and CH2 is S, or
CH3 is M and CH4 is S, or CH5 is M and CH6 is S etc.

In addition to the appropriate CCM type, the firmware must be _notified_
which channels are M+S pairs, via SW4. The **OFF** setting of the switch
corresponds to a M+S pair, while the **ON** state is the setting for two
single masters

| SW4 switch | Channels |
|------------|----------|
| 1          | CH1 & 2  |
| 2          | CH3 & 4  |
| 3          | CH5 & 6  |
| 4          | CH7 & 8  |

!!! note
    When setting up master/slave CCM pairs, slave CCMs should always be on even
    numbered CCMs.

![](lvr_config1.png)

![](lvr_config2.png)

!!! note
    In the current firmware, SW5 contains enables for CH1-4, CH5-8 and a global
    standby. To operate the regulator SW5 must be set as: (OFF, OFF, ON, OFF)

![](lvr_config3.png)

Tom's notes on the configuration switches for the LVR, including
master/slave and general enables.

!!! danger "IMPORTANT"
    ** THE CONVENTION HERE IS OPPOSITE WHAT YOU EXPECT BECAUSE THESE ARE SHORTING
    PULL-UPS. "ON" ON THE SWITCH IS LOGIC 0 AND "OFF" IS LOGIC 1.**

    Also please note that the physical order is 3,2,4,5 and **NOT** 2,3,4,5.

Note that LVR Configuration is done via the CCMs and the potentiometers
P3 and P4, which should be set according to the CCMs to be installed as

| Vos [V] | Vout [V] |
|---------|----------|
| 1.775   | 2.5      |
| 1.546   | 1.5      |
| 1.483   | 1.225    |

P3 controls CH1-CH4, P4 controls CH5-CH8, and each group of four must
use the same CCM Vout. Vos may be measured across TP9-TP10 for CH1-4,
and TP14-15 for CH5-8.


## Overtemperature/Undervoltage Lockout

The overtemperature lockout is configured by SW1. SW1 represents a
binary number with switch 1 the LSB and switch 4 the MSB. Settings which
have been explored in the lab are (in big endian, `LSB -> MSB`)

| Binary setting | LVR shuts off at [C] |
|----------------|----------------------|
| `0101`         | 39                   |
| `1101`         | 30                   |
| `1001`         | 55                   |
| `0001`         | 70                   |

The slice test could easily run at either of the last two.

The undervoltage lockout is configured by SW6(A, B, C, D). We note the
following configurations for each SW6\#. Note that if 4 in SW6\#\[1, 2,
3, 4\] is ON, this acts as a bypass for all other switches. We therefore
only consider switcher 1-3:

| SW6 switcher 1-3 | Undervoltage lockout at [V] |
|------------------|-----------------------------|
| `0,0,0`          | 5.9                         |
| `1,0,0`          | 5.4                         |
| `0,1,0`          | 5.1                         |
| `0,0,1`          | 4.6                         |
| `1,1,0`          | 5.1                         |
| `0,1,1`          | 4.1                         |
| `1,1,1`          | 3.9                         |
| `1,0,1`          | 4.6                         |
