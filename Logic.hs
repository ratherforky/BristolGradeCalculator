{-# LANGUAGE RecordWildCards #-}
module Logic where

import Types
import Utility

calculate :: Marks -> Stats
calculate = finalise         -- Stats
          . processAllYears  -- AccStats
          . map processYear  -- [YearStats]
          . getYearMarks     -- [YearMarks]

-- Finalise 

finalise :: AccStats -> Stats
finalise AccStats{..} = Stats{..}
  where
    finalMark = round' (accWeightedMark / fromIntegral accWeight)
    finalGrade = calcGrade finalMark accWeightedCredsAbove

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

secondaryRule :: Grade -> CreditsAbove -> Grade
secondaryRule First  credAbove = if first credAbove >= (totalWeightedCredits credAbove `div` 2) then First else TwoOne
secondaryRule TwoOne credAbove = if twoOne credAbove >= (totalWeightedCredits credAbove `div` 2) then TwoOne else TwoTwo
secondaryRule TwoTwo credAbove = if twoTwo credAbove >= (totalWeightedCredits credAbove `div` 2) then TwoTwo else Third
secondaryRule Third  credAbove = if third credAbove >= (totalWeightedCredits credAbove `div` 2) then Third else Fail

-- Process the stats from all the years

processAllYears :: [YearStats] -> AccStats
processAllYears = foldr f (AccStats 0 0 emptyCA [])
  where
    f :: YearStats -> AccStats -> AccStats
    f y@YearStats{..} AccStats{..} = AccStats
      { accWeight       = yearWeighting + accWeight
      , accWeightedMark = yearWeighting `intMul` averageMark + accWeightedMark
      , accWeightedCredsAbove = updateCreditsAbove yearWeighting creditsAbove accWeightedCredsAbove
      , yearStatss = y : yearStatss
      }

updateCreditsAbove :: Int -> CreditsAbove -> CreditsAbove -> CreditsAbove
updateCreditsAbove w new acc = CreditsAbove
  { totalWeightedCredits = w * totalWeightedCredits new + totalWeightedCredits acc
  , first  = w * first new + first acc
  , twoOne = w * twoOne new + twoOne acc
  , twoTwo = w * twoTwo new + twoTwo acc
  , third  = w * third new  + third acc
  }

-- Get stats from year mark

processYear :: YearMark -> YearStats
processYear (YearMark weighting units) = YearStats
  { yearWeighting = weighting
  , totalCredits  = totalCredits
  , weightedMark  = weightedMark
  , averageMark   = averageMark
  , yearGrade     = primaryRule (round' averageMark)
  , creditsAbove  = creditsAbove
  }
  where
    (totalCredits, weightedMark, creditsAbove) = processUnits units

    averageMark = weightedMark / fromIntegral totalCredits

primaryRule :: Int -> Grade
primaryRule mark
  | mark >= 70 = First
  | mark >= 60 = TwoOne
  | mark >= 50 = TwoTwo--s nah, it's the remix
  | mark >= 40 = Third
  | otherwise  = Fail

processUnits :: [UnitMark] -> (Int, Double, CreditsAbove)
processUnits = foldr f (0,0,emptyCA)
  where
    f UnitMark{..} (accTC, accWM, CreditsAbove{..}) = (credits + accTC, fromIntegral (credits*mark) + accWM, accCA')
      where
        accCA' = CreditsAbove
          { totalWeightedCredits = credits + totalWeightedCredits
          , first  = if mark >= 70 then credits + first  else first
          , twoOne = if mark >= 60 then credits + twoOne else twoOne
          , twoTwo = if mark >= 50 then credits + twoTwo else twoTwo
          , third  = if mark >= 40 then credits + third  else third
          }
