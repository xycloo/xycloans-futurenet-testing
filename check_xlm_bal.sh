# use this is you're using the CLI downloaded form releases or built.
#alias soroban="/Users/tommasodeponti/Downloads/soroban"

FEES_ADDR_SECRET="SDOTFZRK3TPVMBWGOWBZQA7DHZOFQGGZ73NJTOQZQDRCDTVRIGRBN4KG"

soroban contract invoke --id d93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813 --secret-key $FEES_ADDR_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn balance -- --id "$1"
