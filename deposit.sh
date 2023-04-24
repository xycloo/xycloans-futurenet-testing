# use this is you're using the CLI downloaded form releases or built.
# alias soroban="/Users/tommasodeponti/Downloads/soroban"

PROXY="7fd59b4aa2c634157a08727406e37dc8b4a4b68c4ea4e747ea4bf17073f18f6e"
PROXY_ADDR="CB75LG2KULDDIFL2BBZHIBXDPXELJJFWRRHKJZ2H5JF7C4DT6GHW4PJQ"

# Your settings:
LP_SECRET="SA7CSNFW2GEYFEGE4C4SXJXMUO5FPS3FKR6NCDT2OL6HNCBBUPDUXP2R"
LP="GBPJDMWSKQBHEO3IERFOHTTIICWXDXILVVXENUNPJTG6A2QD2CVATB7C"
AMOUNT=20000000000

soroban contract invoke --id $PROXY --secret-key $LP_SECRET --rpc-url https://future.stellar.kai.run:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022' --fn deposit -- --lender "$LP" --token_contract_id 'd93f5c7bb0ebc4a9c8f727c5cebc4e41194d38257e1d0d910356b43bfc528813' --amount $AMOUNT
