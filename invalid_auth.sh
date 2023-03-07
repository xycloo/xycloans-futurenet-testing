# use this is you're using the CLI downloaded form releases or built.
# alias soroban="/Users/tommasodeponti/Downloads/soroban"

PROXY="7fd59b4aa2c634157a08727406e37dc8b4a4b68c4ea4e747ea4bf17073f18f6e"
PROXY_ADDR="CB75LG2KULDDIFL2BBZHIBXDPXELJJFWRRHKJZ2H5JF7C4DT6GHW4PJQ"
VAULT="7a727ce9308c4fa5f94881f0b1085a74d073d94e73404d09e919d7c3077a20ca"
FLASH_LOAN="6eb470e872ad67527d71c428607212dd5306d7118b54739216c2907a072a4a85"

NOT_PROTOCOL_SECRET="SA5XNOHQE5DRVWHV7UZPTOSBT5QGW5G3GBDRLZJ26O2E3IFQ6CTBS3RI"
NOT_PROTOCOL="GCZLKNLPWQE5M5O6LGBBSEZT72PZ2R7JMYVDLJHLTIDEZXVU63633EBW"

PROTOCOL="GADHYKDDVZBD5DUKS4A6KKOFXEFUZ32PHLAMGDIAGY3STJUDYYZEMORK"

echo "\n\nvalid auth but not as the protocol admin: "

echo "\nset vault: "

soroban contract invoke --id $PROXY --secret-key $NOT_PROTOCOL_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn set_vault -- --admin "$NOT_PROTOCOL" --token_contract_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --vault_contract_id "$VAULT"

echo "\nset flash loan: "

soroban contract invoke --id $PROXY --secret-key $NOT_PROTOCOL_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn set_fl -- --admin "$NOT_PROTOCOL" --token_contract_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --flash_loan_contract_id "$FLASH_LOAN"


echo "\n\nvalid auth but not as the protocol admin: "

echo "\nset vault: "

soroban contract invoke --id $PROXY --secret-key $NOT_PROTOCOL_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn set_vault -- --admin "$PROTOCOL" --token_contract_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --vault_contract_id "$VAULT"

echo "\nset flash loan:"
soroban contract invoke --id $PROXY --secret-key $NOT_PROTOCOL_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn set_fl -- --admin "$PROTOCOL" --token_contract_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --flash_loan_contract_id "$FLASH_LOAN"

