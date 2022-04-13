## VTTx depopulation

As the backplanes depopulate, for some DCBs only some GBTxs are used. The
backplane design rules specify that when GBTxs are unused the unused GBTxs are
always `GBTx4` and `GBTx5`.  For these boards the optical mezzanine for `GBTx4-5`
does not need to be installed, in addition to (entire) DCB boards' depopulation. 

<img src="https://user-images.githubusercontent.com/12600353/163211879-f23002a2-8fbf-4389-83e5-2b65f393caf1.png" width="600">

!!! note
    I do not believe any special jumpers need to be installed but I will verify
    this (Will).


## DCB placement with depopulated VTTx
The backplane mapping specifies which pairs of GBTxs are unused in the
detector. They can be translated from "proto" `JD` slots to True and Mirror `JD`
slots with the following table[^1]:

| Proto  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|--------|---|---|---|---|---|---|---|---|---|---|----|----|
| True   | 0 | 4 | 2 | 3 | 1 | 5 | 6 | 8 | 7 | 9 | 10 | 11 |
| Mirror | 4 | 0 | 3 | 2 | 5 | 1 | 8 | 6 | 9 | 7 | 11 | 10 |


[^1]: Copied from [Zishuo's notes on mapping](https://github.com/ZishuoYang/UT-Backplane-mapping/issues/52).


- Full backplane: This backplane has no depopulated DCBs
- Partially depopulated backplane: `JD` slots `1, 5, 6, 8` should have DCBs 
  with depopulated VTTx. This applies to both True and Mirror backplanes.
- Depopulated backplane: In addition to `JD 1, 5, 6, 8`, slots `7, 9` should
  also DCBs with depopulated VTTx.  This applies to both True and Mirror
  backplanes.

The total number of DCBs with depopulated VTTx is 72:
```
12 P backplanes * 4 DCBs + 4 D backplanes * 6 DCBs
```
