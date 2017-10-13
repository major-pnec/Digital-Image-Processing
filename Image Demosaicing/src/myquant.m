function q = myquant(x, w)
q=floor((x./(w+eps)));%adding a small quantity in order to avoid 1/w=2^bits, otherwise we will need one more bit
                     %to represent number 8 or number 256


