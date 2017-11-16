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

bytesVal :: BytesN 32
bytesVal = BytesN . BA.convert . fst . BS16.decode . T.encodeUtf8 $ "0000000000000000000000000000000000000000000000000000000000000031"

bytesVal2 :: BytesN 32
bytesVal2 = BytesN . BA.convert . fst . BS16.decode . T.encodeUtf8 $ "0000000000000000000000000000000000000000000000000000000000000032"

bytesVal3 :: BytesN 32
bytesVal3 = BytesN . BA.convert . fst . BS16.decode . T.encodeUtf8 $ "0000000000000000000000000000000000000000000000000000000000000033"

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
        hash <- Web3.sha3 "0x3922"
        sig <- Eth.sign coinbase hash
        oneVal <- getOne callVal
        twoTimesSeven <- multiplySeven callVal 2
        res <- arrayTest callVal [bytesVal, bytesVal2, bytesVal3]
        res2 <- arrayTestC callVal [bytesVal, bytesVal2, bytesVal3] bytesVal2
        return $ show (netVersion, blockNumber, balance, accounts, hash, sig, oneVal, twoTimesSeven, res, res2)
    where
        bytesArr = [bytesVal, bytesVal2, bytesVal3]
        callVal = def { callTo = contractAddress, callFrom = Just coinbase }
