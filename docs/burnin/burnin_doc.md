# Intro
The "burn-in" stage of testing is to ensure that the LVRs can be used in the
final system at CERN. The burn-in uses both hardware and software which were
designed at UMD.

The burn-in testing makes extensive use of the software in the repo
`NeoBurnIn`. This repo also imports software from repo `rpi.burnin`.


# Hardware Configuration
The hardware system has four major components, the MARATON power supply, the
crate containing the LVRs, the crate containing the switching load boards,
and a single raspberry pi.

The MARATON power supply is connected to the crate containing the LVRs and
is used to provide power to the separate LVR channels.

The LVRs connect to the crate containing the switching load boards and
have their output connected to the switching load boards.

The switching load boards and the single raspberry pi are the parts of the
hardware configuration that require the most setup so they will each receive
their own section.

A picture of the final hardware configuration is shown below.

**INSERT PIC ZISHUO SENT HERE.**

## Switching Load Board Setup
The switching load boards are used to increase the current output by the
LVRs. A picture of the board is shown below.

**INSERT SLB PIC HERE**

From the picture there are two separate connections which will have pinouts
to other hardware. The two pinouts on the upper left-side of the board
(`P101`) are labeled as `V Opto Sec. 5V`. These pinouts are connected to a
function generator which provides a 5V DC connection to the switching load
board. The positive and negative terminals connect to the respective
positve and negative terminals of the function generator.

The second connection are the two pinouts on the upper right-side of the
board (`P102`) which are labeled as `RPi GPIO Control`. The positive
terminal of this connection connects to one of the many GPIO pins on the
raspberry pi and the negative terminal connects to one the the raspberry pi
pins labeled `GND`. Any GPIO pins that occur on the pi at pins 11 or lower
can not be conencted to the switching load boards as these GPIO pins are
reserved for other hardware. This will be further explained in the section
describing the raspberry pi hardware setup.

Additionally, a python script was made which will pull the GPIO pin
connected to the switching load board high for 60 seconds, then pull
the pin low for 10 seconds and repeat this process until the user
interrupts this process (from Ctrl+C). Pulling the GPIO pin high will
power the switching load board and tell it to increase the current
output by the LVRs. The python script will be described more with the
other software below.

## Raspberry Pi Setup
The single raspberry pi for the hardware is considered the brain of the
system as this pi controls all of the software for the system and controls
the power to the hardware.

The raspberry pi for this system is version RPi 3B+ and has a MicroSD card
configured to run the `NixOS` operating system (linux based). The pi must
be connected to a monitor and keyboard in order to control the system.

**Note:** The grounding for the pi is through the shield of the HDMI cord
connecting the monitor to the pi. This means that the monitor conencted to
the pi **must** have a three-prong power cord to ensure that all GNDs in
the system are referencing the Earth GND.

The raspberry pi controls most of the smaller hardware parts of the system
including the USB relay (used to control the CP100 Rain Bird Solenoid Valve),
the water alarm, the fire alarm and all of the thermistors.

**Note:** The power for the thermistors and the fire alarm both come from
the `3.3V` pin of the pi although there is only one `3.3V` pin. To fix
this we made a wire which starts at the `3.3V` pin of the pi and forks
out to make two connections.

#### USB Relay and Solenoid Valve
The USB relay and solenoid valve control the water flowing to the LVR crate.
This water is used for cooling the crate if it gets too hot. A diagram of
the circuit is shown below.

**INSERT USB RELAY PIC HERE**

The USB relay in this diagram would be connected to the raspberry pi via USB.
Multiple solenoid valves can be inserted into this system although now we
only have one solenoid valve in use as each solenoid valve in the system
requires its own diode and normally open (NO) terminal.

#### Water Alarm
The water alarm is used to measure if water is leaking on the floor next to
the crate containing the LVRs. This would occur if the tubes connected to
the solenoid valve started to leak. If water is detected then the software
will output a `WATER` message. The water alarm is a
[floor water sensor by Level Sense](https://www.amazon.com/Floor-Water-Sensor-Flood-Detection/dp/B079YB1T8J/ref=cm_cr_srp_d_product_top?ie=UTF8 "Water Sensor on Amazon").

The water alarm has a red wire, which is connected to one of the `5V`
connections on the pi, and a white wire, which is connected to pin 11 of
the pi (`GPIO17`) with a pull-down resistor of 4.7k.

#### Fire Alarm
The fire alarm is used to detect if smoke is rising from the crate
containing the LVRs. If smoke is detected then the alarm will trigger
and the software will output a `FIRE` message.

The fire alarm has three connections to the pi. The grey wire from the
alarm will connect to one of the `GND` pins of the pi. The blue wire
from the alarm has two connections with a pull-down resistor
connecting them. The red only wire soldered to the blue wire is the
power for the alarm and is connected to one of the forked `3.3V`
connections. The red wire with black markings soldered to the blue
wire is the control for the alarm and is connected to pin 8
(`GPIO14`) of the pi.

#### Thermistors
The thermistors are used to measure the temperature of the LVRs being
burned-in. The thermistors have their values averaged to obtain the
nominal temperature of the crate.

If the crate has a temperature of 30C or higher then the solenoid
valve is turned to allow water to flow to the crate and aid in cooling
the crate. Once the crate has a temperature of 29C or lower then the
solenoid valve is turned off and water flow stops to ensure that
the crate does not continue to cool.

The thermistors all have their GND legs soldered to their VDD legs
and are connected in parallel to each other via a breakout board
connected to the pi. The breakout board has one rail for the GND
connection of each thermistor and one rail for the data obtained
by the thermistor. A diagram of the circuit is shown below.

**INSERT THERM CIRCUIT PIC HERE**

The connections to the pins of the pi in the diagram are the same
as the connections to the pins of the pi in use for the burn-in.


# Software
The software for the burn-in is all run through the raspberry pi
and comes from the repo `NeoBurnIn`. Some software also comes
from the `rpi.burnin` repo although the necessary software
from this repo is downloaded from the command shown in the
**Dependencies** section.

In order to run to the burn-in software one must first clone
the `master` branch of the `NeoBurnIn` repo. After cloning,
change directory to the recently cloned `NeoBurnIn` repo and
isuue the command:
```
nix-shell
```

This will setup the evironment for the software to be run
correctly.

## Dependencies
After setting up the environment, the required packages for
the software must be downloaded. All required packages can be
installed with:
```
pip install -U -r ./requirements.txt
```

## Configuration
The configuration of all data logging and hardware is included
in the YAML files for each of the python scripts. These YAML are:
- `NeoBurnIn/DataServer.example.yml`
- `NeoBurnIn/CtrlServer.example.yml`
- `NeoBurnIn/measurements/test_temp_ctrl_client.yml`

`NeoBurnIn/DataServer.example.yml` controls the setup for the
output log file from `DataServer.py`. This YAML file also
controls the standard deviation range to use for the
thermistor readout warning.

`NeoBurnIn/CtrlServer.example.yml` controls the setup for the
output log file from `CtrlServer.py`. This YAML file also
controls the IP address and port number of the raspberry pi
to be used for the `curl` commands which control the USB
relay. Additionally, this YAML file controls the time intervals
on which the USB relay and MARATON power supply can be
controlled. For example, in this file if the variable
`relay_timer` is set to `60` then this means that the channels
of the USB relay can only be switched from on to off or
vice-versa every 60 seconds.

`NeoBurnIn/measurements/test_temp_ctrl_client.yml` controls
the setup for the output log file from `CtrlClient.py`.
This YAML file also controls the setup of the thermistors,
the setup of the MARATON power supply and the setup of both
alarms (these controls are under the label `sensors`).
Additionally, this YAML file controls the setup for the
control commands of both the USB relay and the MARATON
power supply (these controls are under the label
`controllers`). Note that the control for the USB relay in
this YAML file is only the control from the thermistors but 
**not** the control from the `curl` commands. Also, this YAML
file controls the rules for when to turn on/off the cooling
from the solenoid valve (these controls are under the label
`ctrlRules`).

## Usage


## Controlling the PSU (MARATON) with `curl`


## Controlling the USB Relay with `curl`
