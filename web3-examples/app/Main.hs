{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-cse #-}

module Main where

import qualified Data.ByteArray as BA
import qualified Data.ByteString.Base16 as BS16
import           Data.Default
import           Data.Either (fromRight)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import           Network.Ethereum.Contract.TH
import           Network.Ethereum.Web3
import           Network.Ethereum.Web3.Eth      (getTransactionCount)
import           Network.Ethereum.Web3.Types
import           Network.Ethereum.Web3.Provider

-- create functions to call the Example contract
[abiFrom|data/Example.abi|]

privKey = fst . BS16.decode $ T.encodeUtf8 "7231a774a538fce22a329729b03087de4cb4a1119494db1c10eae3bb491823e7"
coinbase = "0x198e13017d2333712bd942d8b028610b95c363da"
contractAddress = "0x6cec7c2c13fc0d8a4ece2e9711e3a965b8cd9c54"

provider = Provider (HttpProvider "http://localhost:8548")
                    (Just (SigningConfiguration privKey 88888))

main :: IO ()
main = do
    result <- runWeb3' provider testProgram
    print result

testProgram :: Web3 String
testProgram = do
        currentNonce <- getTransactionCount coinbase Latest
        let callVal = def { callTo = Just contractAddress
                          , callFrom = Just coinbase
                          , callNonce = Just currentNonce
                          , callGasPrice = Just 10000000000000
                          }
            secondCallVal = def { callTo = Just contractAddress
                                , callFrom = Just coinbase
                                }
        setA callVal 1023
        val <- getDoubleA secondCallVal
        return $ show val
