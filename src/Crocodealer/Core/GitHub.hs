module Crocodealer.Core.GitHub
       ( UserName (..)
       , RepoName (..)
       , FileName (..)
       ) where

newtype UserName = UserName
    { unUserName :: Text
    } deriving (Show, Eq)

newtype RepoName = RepoName
    { unRepoName :: Text
    } deriving (Show, Eq)

newtype FileName = FileName
    { unFileName :: Text
    } deriving (Show, Eq)
