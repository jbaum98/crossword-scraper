{-# LANGUAGE OverloadedStrings #-}

import Text.HTML.Scalpel
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as B
import Text.StringLike
import Lib

puzzleLink :: (Ord str, Show str, StringLike str) => Scraper str str
puzzleLink = chroot "a" $ do
    guard =<< text anySelector <&> (== "Solve puzzle in AcrossLite format")
    attr "href" anySelector

main :: IO ()
main = scrapeStdIn puzzleLink B.putStrLn
