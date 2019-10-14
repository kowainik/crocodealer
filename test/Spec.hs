module Main (main) where

import Test.Hspec (hspec)

import Crocodealer.Config (loadConfig)
import Test.Config (testConfig)

main :: IO ()
main = do 
    config <- loadConfig "example-config.toml"
    hspec $ testConfig config
