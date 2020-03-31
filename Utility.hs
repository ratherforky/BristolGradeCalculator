module Utility where

-- Not strictly correct rounding mode
roundDiv :: Integral a => a -> a -> a
roundDiv x y = round (fromIntegral x / fromIntegral y)

round' :: (RealFrac a, Integral b) => a -> b
round' = round

fracDiv :: (Integral a, Fractional b) => a -> a -> b
fracDiv x y = fromIntegral x / fromIntegral y

intMul :: (Integral a, Num b) => a -> b -> b
intMul x y = fromIntegral x * y