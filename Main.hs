{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

import Text.HTML.Scalpel
import Control.Monad
import Text.Regex
import qualified Network.Curl as Curl
import Data.Maybe
import Control.Applicative
import qualified Control.Monad.Parallel as Par

type Link = String

allLinks :: String -> IO (Maybe [Link])
allLinks = flip scrapeURL links
   where
       links :: Scraper String [Link]
       links = chroot ("div" @: ["id" @= "articlebody"] // "p") $ do
           s <- text "b"
           guard $ s == "Previous Monday Crosswords"
           attrs "href" "a"

conf = (Config { decoder = iso88591Decoder, curlOpts = [Curl.CurlFollowLocation True, Curl.CurlHttpHeaders headers, Curl.CurlEncoding "gzip, deflate, br", Curl.CurlNoProgress True, Curl.CurlFailOnError False]})
    where headers = []--[ "DNT: 1"
                    --, "Connection: keep-alive"
                    --, "Upgrade-Insecure-Requests: 1"
                    --, "Cache-Control: max-age=0"
                    --]

puzzleLink :: String -> IO (Maybe Link)
puzzleLink url = scrapeURLWithConfig conf url $ chroot "a" $ do
    s <- text anySelector
    --guard $ s == "Solve puzzle in AcrossLite format"
    --attr "href" anySelector
    return s

baseUrl :: Link
baseUrl = "https://web.archive.org/web/20121119013907/http://puzzles.about.com/od/beginnersxwords/a/eznytcrosswords.htm"


main = getAllLinks >>= (mapM (\url -> (url,) <$> puzzleLink url ) . take 20) >>= mapM_ (putStrLn . show)
    where
        getAllLinks :: IO [Link]
        getAllLinks = fmap fromJust (allLinks baseUrl)

--main = puzzleLink "https://web.archive.org/web/20121119013907/http://puzzles.about.com/od/freeeasynytimescrossword/qt/Jun1807.htm" >>= (putStrLn . show)
