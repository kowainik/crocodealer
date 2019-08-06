module Crocodealer.Core.Label
       ( LabelRule (..)
       , Label (..)
       , Name (..)
       , HexColor (..)
       ) where


newtype Name a = Name
    { unName :: Text
    } deriving (Show)

newtype HexColor = HexColor
    { unHexColor :: Text
    } deriving (Show)

data Label = Label
    { labelName        :: !(Name Label)
    , labelDescription :: !Text
    , labelColor       :: !HexColor
    } deriving (Show)

-- | Create a Label or Override an existing one
data LabelRule
    = Create !Label -- | Create a Label from scratch.
    | Override     -- | Override an existing label. 
    !(Name Label)   -- | First parameter is the existing label to be overridden.
    !(Name Label)   -- | Second parameter is the new label value.
    deriving (Show)
              
