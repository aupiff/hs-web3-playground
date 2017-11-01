{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-cse #-}

module Main where

import           Data.Either (fromRight)
import           Network.Ethereum.Web3
import qualified Network.Ethereum.Web3.Address as Addr
import qualified Network.Ethereum.Web3.Eth as Eth
import qualified Network.Ethereum.Web3.Net as Net
import qualified Network.Ethereum.Web3.Web3 as Web3
import           Network.Ethereum.Web3.TH
import           Network.Ethereum.Web3.Types



-- create functions to call the Example contract
[abiFrom|data/Example.abi|]

coinbase = "0x198e13017d2333712bd942d8b028610b95c363da"
contractAddress = fromRight Addr.zero $ Addr.fromText "0x6cec7c2c13fc0d8a4ece2e9711e3a965b8cd9c54"

data TestProvider

instance Provider TestProvider where
    rpcUri = return "http://localhost:8548"

main :: IO ()
main = do
    result <- runWeb3' testProgram
    print result

testProgram :: Web3 TestProvider String
testProgram = do
        netVersion <- Net.version
        blockNumber <- Eth.blockNumber
        balance <- Eth.getBalance coinbase Latest
        accounts <- Eth.accounts
        hash <- Web3.sha3 "When to the sessions of sweet, silent thought"
        sig <- Eth.sign coinbase hash
        twoTimesSeven <- multiplySeven contractAddress 2
        return $ show (accounts, netVersion, blockNumber, balance, sig, hash, contractAddress, twoTimesSeven)
