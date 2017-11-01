{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import           Network.Ethereum.Web3
import           Network.Ethereum.Web3.Address
import qualified Network.Ethereum.Web3.Eth as Eth
import qualified Network.Ethereum.Web3.Net as Net
import           Network.Ethereum.Web3.TH



-- create functions to call the Example contract
[abiFrom|data/Example.abi|]

coinbase = "0x198e13017d2333712bd942d8b028610b95c363da"

main :: IO ()
main = do
    result <- runWeb3 $ do
        netVersion <- Net.version
        blockNumber <- Eth.blockNumber
        balance <- Eth.getBalance coinbase Latest
        hash <- Web3.sha3 "When to the sessions of sweet, silent thought"
        sig <- Eth.sign coinbase hash
        twoTimesSeven <- multiplySeven
        return (netVersion, blockNumber, balance, sig, hash)
    print result
