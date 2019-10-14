module Test.Config (testConfig) where

import Test.Hspec (describe, it, SpecWith, shouldBe)

import Crocodealer.Config (Config(..), Repo(..))
import Crocodealer.Core.Label (Label(..), LabelRule(..), Name(..), HexColor(..))

exampleLabel :: Label
exampleLabel = Label 
    { labelName = Name {unName = "label1"}
    , labelDescription = "a cool label"
    , labelColor = HexColor {unHexColor = "#000000"}
    }

exampleConfigLabelrules :: [LabelRule]
exampleConfigLabelrules = 
   [ Create exampleLabel
   , Override (Name {unName = "old label name"}) (Name {unName = "new label name"})
   ]

exampleConfig :: Config
exampleConfig = 
    Config { configUsername =  Just "my-user"
           , configRepository = Just "my-org/my-repo"
           , configIgnoredRepositories = 
               [ Repo {unRepo = "my-ignored-repo"}
               , Repo {unRepo = "my-other-ignored-repo"}
               ]
           , configLabelRules = exampleConfigLabelrules
           }

testConfig :: Config -> SpecWith ()
testConfig config = describe "Config.loadConfig" $ 
    it "Should load the sample configuration correctly" $
        config `shouldBe` exampleConfig
