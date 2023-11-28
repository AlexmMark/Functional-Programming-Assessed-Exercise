{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_connect4 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/alexmark/Documents/Uni/Y4/FP/Functional-Programming-Assessed-Exercise2023/.stack-work/install/x86_64-osx/e37c0dc34de006cd5d1cd2053733d8543b73a12f676336d758c526e00a765f36/9.4.7/bin"
libdir     = "/Users/alexmark/Documents/Uni/Y4/FP/Functional-Programming-Assessed-Exercise2023/.stack-work/install/x86_64-osx/e37c0dc34de006cd5d1cd2053733d8543b73a12f676336d758c526e00a765f36/9.4.7/lib/x86_64-osx-ghc-9.4.7/connect4-0.1.0.0-kUkhJ1G7nI5QiK0T8ijFM"
dynlibdir  = "/Users/alexmark/Documents/Uni/Y4/FP/Functional-Programming-Assessed-Exercise2023/.stack-work/install/x86_64-osx/e37c0dc34de006cd5d1cd2053733d8543b73a12f676336d758c526e00a765f36/9.4.7/lib/x86_64-osx-ghc-9.4.7"
datadir    = "/Users/alexmark/Documents/Uni/Y4/FP/Functional-Programming-Assessed-Exercise2023/.stack-work/install/x86_64-osx/e37c0dc34de006cd5d1cd2053733d8543b73a12f676336d758c526e00a765f36/9.4.7/share/x86_64-osx-ghc-9.4.7/connect4-0.1.0.0"
libexecdir = "/Users/alexmark/Documents/Uni/Y4/FP/Functional-Programming-Assessed-Exercise2023/.stack-work/install/x86_64-osx/e37c0dc34de006cd5d1cd2053733d8543b73a12f676336d758c526e00a765f36/9.4.7/libexec/x86_64-osx-ghc-9.4.7/connect4-0.1.0.0"
sysconfdir = "/Users/alexmark/Documents/Uni/Y4/FP/Functional-Programming-Assessed-Exercise2023/.stack-work/install/x86_64-osx/e37c0dc34de006cd5d1cd2053733d8543b73a12f676336d758c526e00a765f36/9.4.7/etc"

getBinDir     = catchIO (getEnv "connect4_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "connect4_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "connect4_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "connect4_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "connect4_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "connect4_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
