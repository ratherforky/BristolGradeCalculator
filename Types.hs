module Types where

newtype Marks = Marks { unMarks :: [YearMark] }

data YearMark = YearMark
  { weighting :: Int
  , units     :: [UnitMark]
  } deriving Show

data UnitMark = UnitMark
  { unitName :: String
  , credits  :: Int
  , mark     :: Int
  } deriving Show

data Calculations = Calc
  { finalGrade :: Grade
  , finalMark  :: Int
  } deriving Show

data AccCalc = AccCalc
  { accWeight             :: Int
  , accWeightedMark       :: Double
  , accWeightedCredsAbove :: CreditsAbove
  , yearCalcs             :: [YearCalc]
  } deriving Show

data YearCalc = YearCalc
  { yearWeighting :: Int
  , totalCredits  :: Int
  , weightedMark  :: Double
  , averageMark   :: Double
  , yearGrade     :: Grade
  , creditsAbove  :: CreditsAbove
  } deriving Show

data Grade = First | TwoOne | TwoTwo | Third | Fail deriving Show

data CreditsAbove = CreditsAbove
  { totalWeightedCredits :: Int
  , first  :: Int
  , twoOne :: Int
  , twoTwo :: Int
  , third  :: Int
  } deriving Show

emptyCA = CreditsAbove 0 0 0 0 0