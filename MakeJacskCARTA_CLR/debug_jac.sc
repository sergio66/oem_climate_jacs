/bin/rm JUNK/x.jac JUNK/x.dat

time /home/sergio/KCARTA/BIN//kcarta.x_f90_400ppmv_H16_6gasjacob JUNK_SUCCESS/run_nml21_1305_1605      JUNK_SUCCESS/x.dat JUNK_SUCCESS/x.jac

## debug
#time /home/sergio/KCARTA/BIN/kcarta.x_f90_400ppmv_H16_6gasjacob_g1_g103 JUNK/run_nml21_1305_1605      JUNK/x.dat JUNK/x.jac
#time /home/sergio/KCARTA/BIN/kcarta.x_f90_400ppmv_H16_6gasjacob_g110    JUNK/run_nml21_1305_1605      JUNK/x.dat JUNK/x.jac
#time /home/sergio/KCARTA/BIN/bkcarta.x_400ppmv_H16_6gas_jacob_V112_g110 JUNK/run_nml21_1305_1605_V112 JUNK/x.dat JUNK/x.jac

ls -lth JUNK
