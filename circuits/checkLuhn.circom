pragma circom 2.0.0;

include "luhn.circom";

component main {public [values]} = checkLuhn(16);