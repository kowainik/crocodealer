module Crocodealer.Core.Label
       ( LabelRule (..)
       , Label (..)
       , Name (..)
       , HexColor (..)
       , labelRuleCodec
       ) where

import Toml (Codec (..), Key, TomlCodec, (.=))
import qualified Toml

-- TODO remove this from here when it's part of tomland library
disum
    :: (Functor r, Alternative w)
    => (c -> Maybe d) -- ^ Mapper for consumer
    -> (a -> b)       -- ^ Mapper for producer
    -> Codec r w d a  -- ^ Source 'Codec' object
    -> Codec r w c b  -- ^ Target 'Codec' object
disum match ctor codec = Codec
    { codecRead = ctor <$> codecRead codec
    , codecWrite = \c -> case match c of
        Nothing -> empty
        Just d  -> ctor <$> codecWrite codec d
    }

newtype Name a = Name
    { unName :: Text
    } deriving (Show)

-- | TOML Codec for the 'Name' data type.
nameCodec :: Key -> TomlCodec (Name a)
nameCodec name = Toml.diwrap $ Toml.text name

-- | TOML Codec for the 'HexColor' data type.
newtype HexColor = HexColor
    { unHexColor :: Text
    } deriving (Show)

hexColorCodec :: TomlCodec HexColor
hexColorCodec = Toml.dimap unHexColor HexColor $ Toml.text "color"

data Label = Label
    { labelName        :: !(Name Label)
    , labelDescription :: !Text
    , labelColor       :: !HexColor
    } deriving (Show)

-- | TOML Codec for the 'Label' data type.
labelCodec :: TomlCodec Label
labelCodec = Label
    <$> nameCodec "name" .= labelName
    <*> Toml.text "description" .= labelDescription
    <*> hexColorCodec .= labelColor

-- | Create a Label or Override an existing one
data LabelRule
    = Create !Label -- | Create a Label from scratch.
    | Override     -- | Override an existing label.
    !(Name Label)   -- | First parameter is the existing label to be overridden.
    !(Name Label)   -- | Second parameter is the new label value.
    deriving (Show)

-- | TOML Codec for overriding labels
namesCodec :: TomlCodec (Name Label, Name Label)
namesCodec = (,)
     <$> nameCodec "old" .= fst
     <*> nameCodec "new" .= snd

matchCreate :: LabelRule -> Maybe Label
matchCreate (Create label) = Just label
matchCreate _              = Nothing

matchOverride :: LabelRule -> Maybe (Name Label, Name Label)
matchOverride (Override old new) = Just (old, new)
matchOverride _                  = Nothing

-- | TOML Codec for the 'LabelRule' data type.
labelRuleCodec :: TomlCodec LabelRule
labelRuleCodec =
    disum matchCreate Create (Toml.table labelCodec "create")
    <|> disum matchOverride (uncurry Override) (Toml.table namesCodec "override")
