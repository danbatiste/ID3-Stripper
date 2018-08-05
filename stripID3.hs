{-        stripID3.hs -- Manually strips ID3 data        -}

import Prelude hiding ( readFile, 
                        writeFile,
                        drop,
                        take )
import Data.ByteString ( readFile, writeFile, drop, take )
import Data.ByteString.Char8 ( pack )
import System.Directory ( getDirectoryContents, createDirectoryIfMissing )
import Data.Function
import Data.List ( findIndex )


ext :: [Char] -> [Char]
ext = reverse . takeUntil (=='.')  . reverse

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil p []       = []
takeUntil p [x]      = [x]
takeUntil p [x,y]    = (x:m)
    where m    = if p x then [y] else []
takeUntil p (x:y:zs) = (x:m) ++ rest
    where m    = if p x then [] else [y]
          rest = if p y then [] else takeUntil p zs

getTitle :: [Char] -> [Char]
getTitle = takeWhile (/='.') . tail . tail . dropWhile (/='-')

stripID3 :: Bool -> FilePath -> IO ()
stripID3 newdir file = do
    lazycontents <- readFile file
    if (take 3 lazycontents) == (pack "ID3") then do
        contents <- readFile file
        let stripped = drop 3 contents
            in if newdir then do
                     createDirectoryIfMissing False "stripped"
                     writeFile ("stripped/"++file) stripped
                else writeFile file stripped
    else return ()
    
findDiff :: Eq a => [a] -> [a] -> Maybe Int
findDiff f1 f2 = if f1 == f2
                    then Nothing
                    else findIndex (not . not) [(f1 !! n) /= (f2 !! n) | n <- [0..]]
    
stripID3s :: Bool -> [FilePath] -> IO ()
stripID3s _ []     = return ()
stripID3s newdir (f:fs) = do
    stripID3 newdir f
    stripID3s newdir fs


main = do
    contents <- getDirectoryContents ""
    let files = filter ((".mp3"==) . ext) contents
    stripID3s False files
    