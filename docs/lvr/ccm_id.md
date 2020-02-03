CCM identification field guide
========================================

To identify the type of an unknown CCM, first inspect closely the potentiometer (POT-1). There is a 'B' logo, several arrows for benchmark points, and a 3-digit number (see picture). The three digit number may be used to identify the intended output voltage:
![Picture of trimmer pot](trimmer.png)

1. 104 = 1.2V output

2. 203 = 1.5V output

3. 502 = 2.5V output

To identify whether the type is (M)aster, (S)lave or (A)lone (a.k.a. single master), inspect the 6 resistors on the bottom of the CCM (bottom here defined when the CCM is oriented such that the text is readable). From left to right, if we denote an empty pad by 0 and a populated resistor by 1, we have:

1. Subtype A, single master - \[0,0,0,1,1,0\]
![Sense configuration resistors for xxA CCMs](ccm_id_00A.png)

2. Subtype M, master - \[0,1,0,1,1,0\]
![Sense configuration resistors for xxM CCMs](ccm_id_00M.png)

3. Subtype S, slave - \[1,0,1,0,0,1\]
![Sense configuration resistors for xxS CCMs](ccm_id_00A.png)


An example identification is shown in the picture.

![Example of identifying features on 15M CCM](ccm_id.jpeg)
