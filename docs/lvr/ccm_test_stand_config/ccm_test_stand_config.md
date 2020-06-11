# CCM Test Stand Configuration

Configuring the CCM test stand is a 3 staged process. This involves configuring
the test stand based on if the CCM being used is `12, 15, 25`, and `MS` or `A`.

## Stage 1: Load Board

The first stage involves selecting the appropriate load board to plug into the
LVR output. There are two different load boards:

1. For `MS` CCMs

    !!! info "Load board for `MS` CCMs, and where to plug it in"

          ![](ccm_id1.png)

2. For `A` CCMs

    !!! info "Load board for `A` CCMs"

        ![](ccm_id2.png)


## Stage 2: Capacitor Board

The second stage involves setting up the capacitor board. There are 2 different
setting for the capacitor, each setting configuring the LVR for either MS or A
CCMs.

1. To configure `MS` CCMs, connect the left most cables on the capacitor board
    to the right most sockets, as shown in the figure below. In this case, the
    polarity does matter.

    !!! info "Master-Slave CCM Capacitor Board configuration"

        ![](ccm_id3.png)

2. To configure `A` CCMs, connect the right most cables on the capacitor board
    to the right most sockets as shown below. Polarity of the cables does not
    matter in this case.

    !!! info "Alone CCM Capacitor Board configuration"

        ![](ccm_id4.png)


## Stage 3: Resistor Bank

The third and final stage involves configuring the resistor bank shown in the
figure below.

!!! info "Resistor Bank"

    ![](ccm_id5.png)

In this stage, you will be configuring the LVR to either `1.25, 1.5`, or `2.5` V.

In general, when considering voltage and resistance, each channel that you use
has 2.1-2.6 A running through it.

- For some CCM `XXA`, the setup uses 2.1-2.6 A.
- For some CCM `xxM + xxS`, the setup would use 4.2-5.2 A.

When setting up the resistor bank, use jumpers to jump the resistor pins that
you want. It does not matter how you jump the pins (since there are 3 per
resistor) as long as the jumper goes over the middle pin.

The specific resistor board you must configure is shown in the figure above to
have a large cable connected to it (first row middle column). On that resistor
board, you will notice resistor pins arranged as shown below.

!!! info "Resistor Board"

    ![](ccm_id6.png)

    Going from right to left.
