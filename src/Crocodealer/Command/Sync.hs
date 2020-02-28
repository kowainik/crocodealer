module Crocodealer.Command.Sync
       ( sync
       ) where

import Crocodealer.ColorTerminal (errorMessage, infoMessage, warningMessage)
import Crocodealer.Core.GitHub (FileName (..), RepoName (..), UserName (..))

import Shellmet (($|), ($?))


data FileStatus
    = UpToDate
    | Outdated
    | FileDoesNotExist FileName

sync :: UserName -> RepoName -> FileName -> [RepoName] -> IO ()
sync userName templateRepoName fileName repos =
    fetchGitHubFile userName templateRepoName fileName >>= \case
        Nothing -> printFileDiff userName templateRepoName (FileDoesNotExist fileName)
        Just f -> do
            putTextLn $ unFileName fileName
            forM_ repos $ \repo ->
                fetchGitHubFile userName repo fileName >>= \case
                    Nothing -> printFileDiff userName repo (FileDoesNotExist fileName)
                    Just r -> do
                        let fileDiff = calculateDiff f r
                        printFileDiff userName repo fileDiff

fetchGitHubFile :: UserName -> RepoName -> FileName -> IO (Maybe Text)
fetchGitHubFile userName repoName fileName = do
    let url = "https://raw.githubusercontent.com/" <> unUserName userName <> "/" <> unRepoName repoName <> "/master/" <> unFileName fileName
    (Just <$> "curl" $| ["-s", "--fail", url]) $? pure Nothing

printFileDiff :: UserName -> RepoName -> FileStatus -> IO ()
printFileDiff (UserName user) (RepoName repo) = \case
    UpToDate -> infoMessage $ userRepo <> "Up-to-date"
    Outdated -> warningMessage $ userRepo <> "Outdated"
    FileDoesNotExist fileName -> errorMessage
        $ userRepo
        <> "Doesn't have file "
        <> unFileName fileName
  where
    userRepo :: Text
    userRepo = user <> "/" <> repo <> ": "

calculateDiff :: Text -> Text -> FileStatus
calculateDiff templateFile repoFile =
    if templateFile == repoFile
    then UpToDate
    else Outdated
