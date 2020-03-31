module Main where

import Logic
import GradeData (grades) -- Imput your grades here

main :: IO ()
main = putStrLn $ show $ calculate grades