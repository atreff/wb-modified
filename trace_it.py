#!/usr/bin/env python

import sys
sys.path.insert(0, '../Deadpool')
from deadpool_dca import *

def _processinput(iblock, blocksize):
    p='%0*x' % (2*blocksize, iblock)
    return (None, [p[j*2:(j+1)*2] for j in range(len(p)/2)])

def _processoutput(output, blocksize):
    return int(''.join([x for x in output.split('\n') if x.find('OUTPUT')==0][0][10:].split(' ')), 1)

T=TracerPIN(sys.argv[2], processinput, processoutput, ARCH.amd64, 1)
T.run(int(sys.argv[1]))
#T.run(2000)
bin2daredevil(configs={'attack_sbox':   {'algorithm':'AES', 'position':'LUT/AES_AFTER_SBOX'}})
