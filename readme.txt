Irina Nitu, Itoafa Liviu

Based on:
  - Chapter 11.1 and 11.2 from [1]
  - C implementation of the functions from the author's (Ingemar Cox) site
    http://www.cs.ucl.ac.uk/staff/I.Cox
  - chapter 11 equations
  - lab 1 embedders/extractors

- Erasable watermarks (chapter 11.1.3)
  . watermarking with modulo addition, system 16 
    (embeder: E_MOD, detector: D_LC)
    
- Semi-Fragile Watermarks (chapter 11.2.2)
  . semi-fragile watermarking by quantizing DCT coefficients, system 17
    (embeder: E_DCTQ, detector: D_DCTQ)
    For testing, the JPEG compression algorithm using DCT [2] was simulated
    on images after embedding.

[1] I. Cox, M. Miller, J. Bloom - Digital Watermarking and Steganography,  Morgan Kaufmann 2007
[2] K. Cabeen, P. Gent - Image Processing and the Discrete Cosine Transform