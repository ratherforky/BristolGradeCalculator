{-# LANGUAGE RecordWildCards #-}
module Logic where

import Types
import Utility

calcYear :: YearMark -> YearCalc
calcYear (YearMark weighting units) = YearCalc
  { yearWeighting = weighting
  , totalCredits  = totalCredits
  , weightedMark  = weightedMark
  , averageMark   = averageMark
  , yearGrade     = primaryRule (round' averageMark)
  , creditsAbove  = creditsAbove
  }
  where
    (totalCredits, weightedMark, creditsAbove) = foldr f (0,0,emptyCA) units

    f UnitMark{..} (accTC, accWM, CreditsAbove{..}) = (credits + accTC, fromIntegral (credits*mark) + accWM, accCA')
      where
        accCA' = CreditsAbove
          { totalWeightedCredits = credits + totalWeightedCredits
          , first  = if mark >= 70 then credits + first  else first
          , twoOne = if mark >= 60 then credits + twoOne else twoOne
          , twoTwo = if mark >= 50 then credits + twoTwo else twoTwo
          , third  = if mark >= 40 then credits + third  else third
          }

    averageMark = weightedMark / fromIntegral totalCredits

calcGrade :: Int -> CreditsAbove -> Grade
calcGrade mark credsAbove
  | mark >= 70 = First
  | mark >= 68 = secondaryRule First credsAbove
  | mark >= 60 = TwoOne
  | mark >= 68 = secondaryRule TwoOne credsAbove
  | mark >= 50 = TwoTwo
  | mark >= 68 = secondaryRule TwoTwo credsAbove
  | mark >= 40 = Third
  | mark >= 68 = secondaryRule Third credsAbove
  | otherwise  = Fail

primaryRule :: Int -> Grade
primaryRule mark
  | mark >= 70 = First
  | mark >= 60 = TwoOne
  | mark >= 50 = TwoTwo--s nah, it's the remix
  | mark >= 40 = Third
  | otherwise  = Fail

secondaryRule :: Grade -> CreditsAbove -> Grade
secondaryRule First  credAbove = if first credAbove >= (totalWeightedCredits credAbove `div` 2) then First else TwoOne
secondaryRule TwoOne credAbove = if twoOne credAbove >= (totalWeightedCredits credAbove `div` 2) then TwoOne else TwoTwo
secondaryRule TwoTwo credAbove = if twoTwo credAbove >= (totalWeightedCredits credAbove `div` 2) then TwoTwo else Third
secondaryRule Third credAbove = if third credAbove >= (totalWeightedCredits credAbove `div` 2) then Third else Fail

calculate :: Marks -> Calculations
calculate = finalise . calculateAcc

calculateAcc :: Marks -> AccCalc
calculateAcc =  foldr f (AccCalc 0 0 emptyCA []) -- AccCalc
              . map calcYear -- [YearCalc]
              . unMarks      -- [YearMarks]
  where
    f :: YearCalc -> AccCalc -> AccCalc
    f y@YearCalc{..} AccCalc{..} = AccCalc
      { accWeight       = yearWeighting + accWeight
      , accWeightedMark = yearWeighting `intMul` averageMark + accWeightedMark
      , accWeightedCredsAbove = updateCreditsAbove yearWeighting creditsAbove accWeightedCredsAbove
      , yearCalcs = y : yearCalcs
      }

finalise :: AccCalc -> Calculations
finalise AccCalc{..} = Calc{..}
  where
    finalMark = round' (accWeightedMark / fromIntegral accWeight)
    finalGrade = calcGrade finalMark accWeightedCredsAbove

updateCreditsAbove :: Int -> CreditsAbove -> CreditsAbove -> CreditsAbove
updateCreditsAbove w new acc = CreditsAbove
  { totalWeightedCredits = w * totalWeightedCredits new + totalWeightedCredits acc
  , first  = w * first new + first acc
  , twoOne = w * twoOne new + twoOne acc
  , twoTwo = w * twoTwo new + twoTwo acc
  , third  = w * third new  + third acc
  }