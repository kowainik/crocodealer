{- | Configurations through the @config.toml@ file@.
-}

module Crocodealer.Config
       ( Repo (..)
       , Config (..)
       , loadConfig
       ) where

import Toml (TomlCodec, (.=))
import qualified Toml

import Crocodealer.Core.Label as Label

newtype Repo = Repo
    { unRepo :: Text
    } deriving (Show)

-- | TOML Codec for a list of 'Repo'
repoCodec :: Toml.Key -> TomlCodec [Repo]
repoCodec key = Toml.diwrap (Toml.arrayOf Toml._Text key)

data Config = Config
    { configUsername            :: !(Maybe Text)
    , configRepository          :: !(Maybe Text)
    , configLabelRules          :: ![Label.LabelRule]
    , configIgnoredRepositories :: ![Repo]
    } deriving (Show)

-- | TOML Codec for the 'Config' data type.
configCodec :: TomlCodec Config
configCodec = Config
    <$> Toml.dioptional (Toml.text "username") .= configUsername
    <*> Toml.dioptional (Toml.text "template") .= configRepository
    <*> Toml.list Label.labelRuleCodec "labelRule" .= configLabelRules
    <*> repoCodec "ignoredRepositories" .= configIgnoredRepositories

-- | Loads the @config.toml@ file.
loadConfig :: MonadIO m => m Config
loadConfig = Toml.decodeFile configCodec "config.toml"
