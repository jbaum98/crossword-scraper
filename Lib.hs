{-# LANGUAGE LambdaCase #-}

module Lib ((<&>), scrapeStdIn) where

import Text.HTML.Scalpel
import qualified Data.ByteString.Lazy.Char8 as B
import Data.ByteString.Lazy (ByteString)
import System.Exit

(<&>) :: Functor f => f a -> (a -> b) -> f b
as <&> f = f <$> as
infixl 2 <&>

scrapeStdIn :: Scraper ByteString a -> (a -> IO b) -> IO b
scrapeStdIn scraper cont = 
  B.getContents <&> flip scrapeStringLike scraper >>= \case
    Just x -> cont x
    Nothing -> exitFailure
