module Types where

newtype Marks = Marks { getYearMarks :: [YearMark] }

data YearMark = YearMark
  { weighting :: Int
  , units     :: [UnitMark]
  } deriving Show

data UnitMark = UnitMark
  { unitName :: String
  , credits  :: Int
  , mark     :: Int
  } deriving Show

data Stats = Stats
  { finalGrade :: Grade
  , finalMark  :: Int
  } deriving Show

data AccStats = AccStats
  { accWeight             :: Int
  , accWeightedMark       :: Double
  , accWeightedCredsAbove :: CreditsAbove
  , yearStatss            :: [YearStats]
  } deriving Show

data YearStats = YearStats
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

emptyCA :: CreditsAbove
emptyCA = CreditsAbove 0 0 0 0 0