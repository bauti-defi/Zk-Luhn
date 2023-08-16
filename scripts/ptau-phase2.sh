#!/bin/sh

set -e

# Heavily inspired by: https://github.com/cawfree/zk-starter/blob/main/scripts/circuits.ts

# Setup
snarkjs groth16 setup luhn16.r1cs build/pot15_final.ptau build/luhn_final.zkey

snarkjs zkey new luhn16.r1cs build/pot15_final.ptau build/luhn16_0000.zkey

# Ceremony similar to ptau, but for the circuit's zkey this time. Generate commits to the zkey with entropy.
# Zkeys are intended to be hosted on IPFS, since the prover is required to encrypt their data passed into the wasm circuit.
snarkjs zkey contribute build/luhn16_0000.zkey build/luhn16_0001.zkey --name="First luhn16 contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

snarkjs zkey contribute build/luhn16_0001.zkey build/luhn16_0002.zkey --name="Second luhn16 contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

snarkjs zkey contribute build/luhn16_0002.zkey build/luhn16_0003.zkey --name="Third luhn16 contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

# Verify zkey
snarkjs zkey verify luhn16.r1cs build/pot15_final.ptau build/luhn16_0003.zkey

# apply a random beacon
snarkjs zkey beacon build/luhn16_0003.zkey build/luhn16_final.zkey  0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="luhn16 FinalBeacon phase2"

# verify the final zkey, optional
snarkjs zkey verify luhn16.r1cs build/pot15_final.ptau build/luhn16_final.zkey