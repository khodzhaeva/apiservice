//
// Copyright (C) 2020 Signal Messenger, LLC.
// All rights reserved.
//
// SPDX-License-Identifier: GPL-3.0-only
//

#![allow(non_snake_case)]

use crate::common::constants::*;
use crate::common::errors::*;
use crate::common::sho::*;
use crate::common::simple_types::*;
use curve25519_dalek::constants::RISTRETTO_BASEPOINT_POINT;
use curve25519_dalek::ristretto::RistrettoPoint;
use curve25519_dalek::scalar::Scalar;
use serde::{Deserialize, Serialize};

use ZkGroupError::*;

#[derive(Copy, Clone, PartialEq, Serialize, Deserialize)]
pub struct KeyPair {
    pub(crate) signing_key: Scalar,
    pub(crate) public_key: RistrettoPoint,
}

#[derive(Copy, Clone, PartialEq, Serialize, Deserialize)]
pub struct PublicKey {
    pub(crate) public_key: RistrettoPoint,
}

impl KeyPair {
    pub fn generate(sho: &mut Sho) -> Self {
        let signing_key = sho.get_scalar();
        let public_key = signing_key * RISTRETTO_BASEPOINT_POINT;
        KeyPair {
            signing_key,
            public_key,
        }
    }

    // Could return SignatureVerificationFailure if public/private key are inconsistent
    pub fn sign(&self, message: &[u8], sho: &mut Sho) -> Result<SignatureBytes, ZkGroupError> {
        match poksho::sign(
            self.signing_key,
            self.public_key,
            message,
            &sho.squeeze(RANDOMNESS_LEN)[..],
        ) {
            Ok(vec_bytes) => {
                let mut s: SignatureBytes = [0u8; SIGNATURE_LEN];
                s.copy_from_slice(&vec_bytes[..]);
                Ok(s)
            }
            Err(_) => Err(SignatureVerificationFailure),
        }
    }

    pub fn get_public_key(&self) -> PublicKey {
        PublicKey {
            public_key: self.public_key,
        }
    }
}

impl PublicKey {
    // Might return SignatureVerificationFailure
    pub fn verify(&self, message: &[u8], signature: SignatureBytes) -> Result<(), ZkGroupError> {
        match poksho::verify_signature(&signature, self.public_key, message) {
            Err(_) => Err(SignatureVerificationFailure),
            Ok(_) => Ok(()),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_signature() {
        let group_key = TEST_ARRAY_32;
        let mut sho = Sho::new(b"Test_Signature", &group_key);
        let key_pair = KeyPair::generate(&mut sho);

        // Test serialize of key_pair
        let key_pair_bytes = bincode::serialize(&key_pair).unwrap();
        assert!(key_pair_bytes.len() == 64);
        let public_key_bytes = bincode::serialize(&key_pair.get_public_key()).unwrap();
        assert!(public_key_bytes.len() == 32);
        let key_pair2: KeyPair = bincode::deserialize(&key_pair_bytes).unwrap();
        assert!(key_pair == key_pair2);

        let mut message = TEST_ARRAY_32_1;

        let signature = key_pair.sign(&message, &mut sho).unwrap();
        key_pair2
            .get_public_key()
            .verify(&message, signature)
            .unwrap();

        // test signature falure
        message[0] ^= 1;
        match key_pair2.get_public_key().verify(&message, signature) {
            Err(SignatureVerificationFailure) => (),
            _ => assert!(false),
        }

        println!("signature = {:#x?}", &signature[..]);
        let signature_result = [
            0xdb, 0x9b, 0xfb, 0xd6, 0x15, 0x26, 0xc3, 0x50, 0xf9, 0xbe, 0x95, 0x17, 0x11, 0x6,
            0xd0, 0x6, 0x52, 0x88, 0xcb, 0x33, 0x3, 0x1b, 0xe7, 0x17, 0x25, 0x24, 0x37, 0x80, 0x53,
            0x2c, 0xaa, 0x7, 0xcb, 0xda, 0x74, 0xc4, 0x19, 0x3b, 0x6e, 0xe6, 0xe9, 0x5f, 0xae,
            0xcd, 0x41, 0xfb, 0x44, 0x19, 0xce, 0xae, 0x3f, 0x4d, 0x63, 0xb9, 0x47, 0x59, 0x27,
            0xe1, 0x10, 0xee, 0xb7, 0x72, 0xb, 0x6,
        ];

        assert!(&signature[..] == &signature_result[..]);
    }
}
