#!/usr/bin/env sh

mkdir -p $CEREMONY_DIR

# Start a new powers of tau ceremony
npx snarkjs powersoftau new bn128 12 $CEREMONY_DIR/pot12_0000.ptau -v

# First contribution
npx snarkjs powersoftau contribute $CEREMONY_DIR/pot12_0000.ptau $CEREMONY_DIR/pot12_0001.ptau --name="First contribution" -v

# Second contribution
npx snarkjs powersoftau contribute $CEREMONY_DIR/pot12_0001.ptau $CEREMONY_DIR/pot12_0002.ptau --name="Second contribution" -v -e="some magic"

# Third contribution
npx snarkjs powersoftau export challenge $CEREMONY_DIR/pot12_0002.ptau $CEREMONY_DIR/challenge_0003
npx snarkjs powersoftau challenge contribute bn128 $CEREMONY_DIR/challenge_0003 $CEREMONY_DIR/response_0003 -e="some more magic"
npx snarkjs powersoftau import response $CEREMONY_DIR/pot12_0002.ptau $CEREMONY_DIR/response_0003 $CEREMONY_DIR/pot12_0003.ptau -n="Third contribution"

# Verify the Powers of Tau
npx snarkjs powersoftau verify $CEREMONY_DIR/pot12_0003.ptau

# Apply a random beacon
npx snarkjs powersoftau beacon $CEREMONY_DIR/pot12_0003.ptau $CEREMONY_DIR/pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

# Prepare phase 2
npx snarkjs powersoftau prepare phase2 $CEREMONY_DIR/pot12_beacon.ptau $CEREMONY_DIR/pot12_final.ptau -v

# Verify the final ptau
npx snarkjs powersoftau verify $CEREMONY_DIR/pot12_final.ptau
