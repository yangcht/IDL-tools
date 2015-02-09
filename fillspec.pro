;+
; NAME:
;   FILLSPEC
;
; PURPOSE:
;   Two days ago I encountered a problem with plotting spectra using:
;     plot, x, y, PSYM=10
;   in IDL when I tried to fill the area between the signal and continuum 
;   with some color. I firstly tried the POLYFILL, but failed with the PSYM,
;   namely unable to set PSYM=10 if using POLYFILL directly. Then I tried to
;   search if there exists any .pro file written by others for this purpose, 
;   but turned out to be nothing. In the end, under the help of Google and
;   Kexin, I found a way through some simple calculation that can solve this 
;   by POLYFILL.
;
; CALLING SEQUENCE:
;   fillspec, x, y, continuum, psym=, linecolor=, fillcolor=
;
; INPUTS:
;   x, y, continuum. The velocity/frequency/wavelength, flux value and 
;   the continuum value. 
;
; KEYWORD INPUTS:
;   psym      =: Set the plotpsym. For plotting the spectrum, we use 10.
;   linecolor =: Set the spetrum stroke color. 
;   fillcolor =: Set the color that fill the space between flux value 
;                and the continuum value.
;
; KEYWORDS SWITCHES:
;   ...
;
; OUTPUTS:
;   ...
;
; EXAMPLES:
;    IDL> x = ...          ; input the velocity/frequency/wavelength array
;    IDL> y = ...          ; input the corresponding flux value array
;    IDL> continuum = ...  ; input the corresponding continuum value array
;    IDL> fillspec, x, y, continuum, psym=10, linecolor=220, fillcolor=50
;
; SIDEEFFECT:
;   ...
;
; RESTRICTIONS:
;   ...
;
; MODIFICATION HISTORY:
;   Write, 2012-04-21, Chentao Yang (yangcht@gmail.com)
;   Only for filling the spectrum after plot the spectrum using 
;   plot and set PSYM as 10.
;   
;   Edited on 2015-01-20, Chentao Yang, 
;   Fix the bug when values beyong YRANGEs are presented. 
;- 


PRO fillspec, x, y, cont, LINECOLOR=LINECOLOR, psym=psym, FILLCOLOR=FILLCOLOR
loadct=5

x_sort=sort(x)
x=x(x_sort)
y=y(x_sort)
n=n_elements(x)

OPLOT, x, y, COLOR=LINECOLOR, psym=psym
        
; Calculate the additional x-values
xnew = (x(0:n-2) + x(1:n-1)) / 2.0D

; Create array containing all x-values
xx = REBIN(xnew, N_ELEMENTS(xnew)*2, /sample)
xx = [min(x), min(x), xx, max(x),max(x)]

; Create array with the corresponding y-values
yy = REBIN(y, N_ELEMENTS(y)*2, /Sample)
yy = [cont, yy, cont]
y_mi_indx = where(yy LT !Y.CRANGE[0])
y_ma_indx = where(yy GT !Y.CRANGE[1])
IF (y_mi_indx[0] GT 0) THEN yy[y_mi_indx]=yy[y_mi_indx]/yy[y_mi_indx]*!Y.CRANGE[0] 
IF (y_ma_indx[0] GT 0) THEN yy[y_ma_indx]=yy[y_ma_indx]/yy[y_ma_indx]*!Y.CRANGE[1] 



; Fill the histogram plot
POLYFILL, xx, yy, COLOR=FILLCOLOR

; Histogram plot
OPLOT, x, y, COLOR=LINECOLOR, psym=psym

END
