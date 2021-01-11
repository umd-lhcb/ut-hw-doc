## VTTx depopulation

As the backplanes depopulate, for some DCBs only some GBTxs are used. The
backplane design rules specify that when GBTxs are unused the unused GBTxs are
always `GBTx4` and `GBTx5`.  For these boards the optical mezzanine for `GBTx4-5`
does not need to be installed.

!!! note
    I do not believe any special jumpers need to be installed but I will verify
    this (Will).


## Depopulated DCB placement
The backplane mapping specifies which pairs of GBTxs are unused in the
detector. They can be translated from "proto" JD slots to True and Mirror `JD`
slots using [Zishuo's mapping](https://github.com/ZishuoYang/UT-Backplane-mapping/issues/52)

- Full backplane: This backplane has no depopulated DCBs
- Partially depopulated backplane: `JD` slots `1, 5, 6, 8` should be filled
  with depopulated DCBs. This applies to both True and Mirror backplanes.
- Depopulated backplane: In addition to `JD 1, 5, 6, 8`, slots `7, 9` should
  also be filled with depopulated DCBs.  This applies to both True and Mirror
  backplanes.

The total number of depopulated DCBs is 72:
```
12 P backplanes * 4 DCBs + 4 D backplanes * 6 DCBs
```
