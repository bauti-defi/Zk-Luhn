pragma circom 2.0.0;

include "luhn.circom";

component main {public [values]} = luhn(16);