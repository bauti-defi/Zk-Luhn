pragma circom 2.14.0;

include "luhn.circom";

component main {public [values]} = luhn(16);