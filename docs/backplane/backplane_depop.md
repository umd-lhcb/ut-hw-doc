## `JD` depopulations

For both _true_ and _mirror_ type, the depopulations are:

- F -> P: `JD2,3` depopulate
- P -> D: `JD10,11` depopulate


## `JP` depopulations

### True backplanes
For F -> P:

|          | P1W   | P1E   | P2W   | P2E   | P3   | P4   |
|----------|-------|-------|-------|-------|------|------|
| JP0      | X     | O     |       | X     | X    | X    |
| JP1      | X     | O     | O     | X     | X    | O    |
| JP2      | X     | O     | O     | X     | X    | O    |
| JP3      | X     | O     |       | X     | X    | X    |
| JP4      | X     | O     |       | X     | X    | X    |
| JP5      | X     | O     |       | X     | X    |      |
| JP6      | X     | O     |       | X     | X    |      |
| JP7      | X     | O     |       | X     | X    | X    |
| JP8      | X     |       |       | X     | X    | X    |
| JP9      | X     |       |       | X     | X    |      |
| JP10     | X     |       |       | X     | X    |      |
| JP11     | X     |       |       | X     | X    | X    |

!!! note
    - **X**: Hybrid is present on both F and P (but may depopulate a few elinks)
    - **O**: Hybrid is depopulated on P
    - blank: not present

!!! info
    P1-P3 are on P2B2, P4 are on Inner BB.

For P -> D: `JP8-11` are all depopulated.

### Mirror backplanes

!!! note
    From the True configuration shown above, the pigtails `JP0-11` can be
    rearranged into the Mirror configuration, by swapping:

    - `JP0/JP1` with `JP2/JP3`
    - `JP4/JP5` with `JP6/JP7`
    - `JP8/JP9` with `JP10/JP11`

For F -> P:

|      | P1W   | P1E   | P2W   | P2E   | P3   | P4   |
|------|-------|-------|-------|-------|------|------|
| JP0  | X     | O     | O     | X     | X    | O    |
| JP1  | X     | O     |       | X     | X    | X    |
| JP2  | X     | O     |       | X     | X    | X    |
| JP3  | X     | O     | O     | X     | X    | O    |
| JP4  | X     | O     |       | X     | X    |      |
| JP5  | X     | O     |       | X     | X    | X    |
| JP6  | X     | O     |       | X     | X    | X    |
| JP7  | X     | O     |       | X     | X    |      |
| JP8  | X     |       |       | X     | X    |      |
| JP9  | X     |       |       | X     | X    | X    |
| JP10 | X     |       |       | X     | X    | X    |
| JP11 | X     |       |       | X     | X    |      |

For P -> D: `JP8-11` are all depopulated, same as true.
