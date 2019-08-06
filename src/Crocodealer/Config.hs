module Crocodealer.Config
       ( Repo (..)
       , Config (..)
       ) where

import Crocodealer.Core.Label as Label


newtype Repo = Repo
    { unRepo :: Text
    }

data Config = Config
    { configUsername            :: !(Maybe Text)
    , configRepository          :: !(Maybe Text)
    , configLabelRules          :: ![Label.LabelRule]
    , configIgnoredRepositories :: ![Repo]
    }
