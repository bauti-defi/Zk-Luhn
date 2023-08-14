pragma circom 2.0.0;

// @dev src: https://github.com/iden3/circomlib/blob/master/circuits/comparators.circom#L24C1-L34C2
template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}

template Multiplier(amount){
    signal input in;
    signal output result;

    var product = amount * in;

    result <== product > 9 ? product - 9 : product; 
}

template sumator() {
    signal input a;
    signal input b;
    signal output sum;

    sum <== a + b;
}

template luhn(length){
    signal input values[length];
    signal result;
    signal output valid;

    component multis[length];

    for(var i = 0; i < length;i++){
        multis[i] = Multiplier(i % 2 == 0 ? 2 : 1);
        multis[i].in <== values[i];
    }

    component sumators[length - 1];

    // offset of 1
    for(var i = 0; i < length - 1; i++){
        sumators[i] = sumator();

        sumators[i].a <== i == 0 ? multis[i].result : sumators[i - 1].sum;
        
        sumators[i].b <== multis[i + 1].result; 
    }

    result <-- sumators[length - 1].sum % 10;
    result <== 10 - result;

    component isZero = IsZero();
    isZero.in <== result;

    valid <== isZero.out;
}
