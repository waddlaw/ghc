{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE CPP #-}

module Main where

import Language.Haskell.TH.Syntax
import Foreign.C.String

$(do
   -- some architectures require a "_" symbol prefix...
   -- GHC defines a LEADING_UNDERSCORE CPP constant to indicate this.
   addForeignSource LangAsm
#if LEADING_UNDERSCORE
      \.global \"_mydata\"\n\
      \_mydata:\n\
#else
      \.global \"mydata\"\n\
      \mydata:\n\
#endif
      \.ascii \"Hello world\\0\"\n"
   return [])

foreign import ccall "&mydata" mystring :: CString

main :: IO ()
main = putStrLn =<< peekCString mystring
