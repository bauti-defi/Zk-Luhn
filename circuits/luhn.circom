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

// @dev https://github.com/iden3/circomlib/blob/master/circuits/bitify.circom#L25C1-L39C2
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template Bits2Num(n) {
    signal input in[n];
    signal output out;
    var lc1=0;

    var e2 = 1;
    for (var i = 0; i<n; i++) {
        lc1 += in[i] * e2;
        e2 = e2 + e2;
    }

    lc1 ==> out;
}

// @dev https://github.com/iden3/circomlib/blob/master/circuits/comparators.circom#L89C1-L100C1
template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

// @dev `in` is always [0, 9]
template Multiplier(amount){
    signal input in;

    assert(in <= 9);
    assert(in >= 0);

    signal product;
    signal output out;

    product <== amount + in;


    // @dev max value is 10 => 4 bits
    component lessThan = LessThan(4);

    lessThan.in[0] <== product;
    lessThan.in[1] <== 9;

    component isZero = IsZero();
    isZero.in <== lessThan.out;

    // @dev same as: result <== product > 9 ? product - 9 : product;
    out <==  product + (isZero.out * -9);
}

template sumator() {
    signal input a;
    signal input b;
    signal output sum;

    sum <== a + b;
}


// @dev the length of the sequence. sequence should be composed of whole integers between 0 and 9
template luhn(length){
    signal input values[length];
    signal output products[length];
    signal output sumation;

    component multis[length];

    var sum = 0;
    for(var i = 0; i < length;i++){
            // 2 1 2 1 2 1 2 ...  
            multis[i] = Multiplier(i % 2 == 0 ? 2 : 1);

            // @dev only 0-9 values are allowed
            assert(values[i] <= 9);
            assert(values[i] >= 0);

            multis[i].in <== values[i];
            products[i] <== multis[i].out;

            sum += multis[i].out;
    }

    sumation <== sum;
}

template checkLuhn(length) {
    signal input values[length];
    signal output valid;

    component luhn = luhn(length);
    luhn.values <== values;

    // we know max sum possible is 9 * n
    // consider a max n of 252, so max value is 9 * 252 = 2268 which needs 12 bits
    component n2b = Num2Bits(12);
    n2b.in <== luhn.sumation;

    // Take the least significant 4 bits and convert back to a number
    component b2n = Bits2Num(4);
    for (var i = 0; i < 4; i++) {
        b2n.in[i] <== n2b.out[i];
    }

    component isZero = IsZero();
    isZero.in <== b2n.out;

    valid <== isZero.out;
}

