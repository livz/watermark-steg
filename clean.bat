@echo off
del /q /s "*.asv"

set im_dir=images
del /q /s %im_dir%\*_e_mod.bmp
del /q /s %im_dir%\*_d_lc*.bmp
del /q /s %im_dir%\*_e_dctq.bmp