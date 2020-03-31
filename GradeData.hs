module GradeData where

import Types

-- No JSON parsing in repl.it, sorry
grades :: Marks
grades = Marks
  [ YearMark 10 -- Second Year
    [ UnitMark "Language Engineering" -- Name of Unit (not really used anywhere)
               20 -- Credit point value
               0  -- Mark
    , UnitMark "Databases and Cloud Concepts"
               10
               100
    , UnitMark "Symbols, Patterns and Signals"
               20
               0
    , UnitMark "Data Structures and Algorithms"
               20
               0
    , UnitMark "Software Product Engineering"
               20
               0
    , UnitMark "Human-Computer Interaction"
               10
               0
    , UnitMark "Concurrent Computing"
               20
               0
    ]
  , YearMark 40 -- Third Year
    [ UnitMark "Machine Learning"
               10
               0
    , UnitMark "Artificial Intelligence with Logic Programming"
               10
               0
    , UnitMark "Image Processing and Computer Vision"
               10
               0
    , UnitMark "An Introduction to High Performance Computing"
               10
               0
    , UnitMark "Types and Lambda Calculus"
               10
               0
    , UnitMark "Web Technologies"
               10
               0
    , UnitMark "Computational Neuroscience"
               10
               0
    , UnitMark "Advanced Algorithms"
               10
               0
    , UnitMark "Group Project"
               40
               0
    ]
  , YearMark 50 -- Fourth Year
    [ UnitMark "Interactive Devices"
               10
               0
    , UnitMark "Advance Computer Architecture"
               10
               0
    , UnitMark "Quantum Information Theory"
               10
               0
    , UnitMark "Information Processing and the Brain"
               10
               0
    , UnitMark "Systems Security"
               10
               0
    , UnitMark "Quantum Computation"
               10
               0
    , UnitMark "Research Proposal"
               20
               0
    , UnitMark "Individual Project"
               40
               0
    ]
  ]
