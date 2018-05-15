{-# LANGUAGE OverloadedStrings #-}

import Text.HTML.Scalpel
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as B
import Text.StringLike
import System.Environment
import Lib

allLinks :: (Ord str, Show str, StringLike str) => str -> Scraper str [str]
allLinks heading =
  chroot ("div" @: ["id" @= "articlebody"] // "p") $ do
     guard =<< text "b" <&> (== heading)
     attrs "href" "a"

main :: IO ()
main = do
  heading : _ <- getArgs
  scrapeStdIn (allLinks $ fromString heading) (mapM_ B.putStrLn)
