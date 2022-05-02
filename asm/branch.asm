.ORIG	x3000

    ADD R1 R1 #6
LOOP
    ADD R1 R1 #-1
    BRp LOOP    

    HALT

.END