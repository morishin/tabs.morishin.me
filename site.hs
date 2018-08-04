--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll
import System.Directory
import Control.Monad (mapM_, forM_)
import System.FilePath.Posix (dropExtension)
import System.FilePath (takeFileName)
import System.Process (system)
import Data.List (isPrefixOf, isSuffixOf)

--------------------------------------------------------------------------------
main :: IO ()
main = do
    generateHTMLFilesFromTabFiles
    hakyllBuild

generateHTMLFilesFromTabFiles :: IO ()
generateHTMLFilesFromTabFiles = do
    files <- listDirectory "./tabs"
    forM_ files $ \file -> do
        let filename = dropExtension file
        writeFile ("tabs/" ++ filename ++ ".html") filename

configuration :: Configuration
configuration = Configuration
    { destinationDirectory = "docs" -- Use "docs" as distination directory name for GitHub Pages
    , storeDirectory       = "_cache"
    , tmpDirectory         = "_cache/tmp"
    , providerDirectory    = "."
    , ignoreFile           = ignoreFile'
    , deployCommand        = "echo 'No deploy command specified' && exit 1"
    , deploySite           = system . deployCommand
    , inMemoryCache        = True
    , previewHost          = "127.0.0.1"
    , previewPort          = 8000
    }
    where
    ignoreFile' path
        | "."    `isPrefixOf` fileName = True
        | "#"    `isPrefixOf` fileName = True
        | "~"    `isSuffixOf` fileName = True
        | ".swp" `isSuffixOf` fileName = True
        | otherwise                    = False
        where
        fileName = takeFileName path

hakyllBuild :: IO ()
hakyllBuild = hakyllWith configuration $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "images/**/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "tab_files/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "css/**/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "javascripts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "javascripts/**/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "tabs/*" $ do
        route idRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" defaultContext
            >>= relativizeUrls

    create ["robots.txt"] $ do
        route idRoute
        compile copyFileCompiler

    create ["CNAME"] $ do
        route idRoute
        compile copyFileCompiler

    create ["index.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "tabs/*"
            let indexCtx =
                    listField "posts" defaultContext (return posts) `mappend`
                    constField "title" "Home" `mappend`
                    defaultContext

            getResourceBody -- Load "index.html" file into `Context (Item String)` type
                >>= applyAsTemplate indexCtx -- Apply `indexCtx` to the template from "index.html"
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler
