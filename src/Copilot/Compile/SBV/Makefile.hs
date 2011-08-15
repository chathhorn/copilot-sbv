--------------------------------------------------------------------------------
-- Copyright © 2011 National Institute of Aerospace / Galois, Inc.
--------------------------------------------------------------------------------

module Copilot.Compile.SBV.Makefile
  ( makefile ) where

import Copilot.Compile.SBV.Driver (driverName)
import Text.PrettyPrint.HughesPJ
import qualified System.IO as I

--------------------------------------------------------------------------------

makefile :: String -> String -> IO ()
makefile dir fileName = do
  let filePath = dir ++ '/' : (fileName ++ ".mk")
  h <- I.openFile filePath I.WriteMode
  let wr doc = I.hPutStrLn h (mkStyle doc)
  wr $    text "/*" 
      <+> text "Makefile rules for the Copilot driver."
      <+> text "*/"
  wr (text "")
  wr $ text (driverName fileName) <> colon 
        <+> text (driverName fileName) <> text ".c"
        <+> (text fileName <> text ".h")
  wr $ nest 2 (hsep [ text "$" <> braces (text "CC")
                    , text "$" <> braces (text "CCFLAGS")
                    , text "$<"
                    , text "-o"
                    , text "$@"
                    , text fileName <> text ".a"])

  where 
  mkStyle :: Doc -> String
  mkStyle = renderStyle (style {lineLength = 80})

--------------------------------------------------------------------------------

