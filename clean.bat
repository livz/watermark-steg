@echo off

del /q /s "*.asv"
del /q /s "*.log"
del /q /s "out.bmp"
del /q /s "out.jpg"

set im_dir=images
del /q /s %im_dir%\*_e_mod.bmp
del /q /s %im_dir%\*_d_lc*.bmp
del /q /s %im_dir%\*_e_dctq*.bmp
