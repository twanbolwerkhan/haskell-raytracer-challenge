{-# LANGUAGE FlexibleInstances #-}
module Matrices where
import Data.Array
import Tuples

data Matrix a = Matrix { getNRows :: Row,
                         getNCols :: Column,                        
                         getArray :: Array (Row, Column) a}
 deriving Show

instance Eq (Matrix Double) where
    a == b = predicate
        where predicate = (getNCols a) == (getNCols b) && 
                          (getNRows a) == (getNRows b) &&
                          (all (==True) (zipWith compare (elems (getArray a)) (elems (getArray b))))
                   where compare a b = abs (a - b) < Tuples.epsilon
instance (Num a, Fractional a) => Num (Matrix a) where
   a * b = listToMatrix [ celCalc a b i j | i <- [0..getNRows a-1], j <- [0..getNCols a-1]]

celCalc :: (Num a, Fractional a) => Matrix a -> Matrix a -> Int -> Int -> a
celCalc a b i j = sum (zipWith (*) (getRow a i 0) (getCol b j 0))

type Column = Int
type Row = Int

{- 
i increments row
j increments column
-}

matrix :: Row -> Column -> ((Row, Column) -> a) -> Matrix a
matrix r c f = Matrix r c (array ((0,0), (c-1, r-1)) [((i,j), f (i,j)) | j <- [0..r-1], i <- [0..c-1]])

getRow :: Matrix a -> Int -> Int -> [a]
getRow m rowNumber index | (snd (snd (bounds arr))) /= index -1 = (arr ! (index,rowNumber)) : getRow m rowNumber (index+1)
                         | otherwise = []
    where arr = getArray m


getCol :: Matrix a -> Int -> Int -> [a]
getCol m colNumber index | (snd (snd (bounds arr))) /= index -1 = (arr ! (colNumber,index)) : getCol m colNumber (index+1)
                            | otherwise = []
    where arr = getArray m
get :: Matrix a -> (Row, Column) -> a
get m (i,j) = (getArray m) ! (i,j)

set :: Matrix a -> (Row, Column) -> a -> Matrix a
set m (i,j) v = Matrix  (getNRows m) (getNCols m) ((getArray m) // [((i, j), v)])

myM :: Matrix Double
myM = matrix 4 4 (\(i,j) -> case j of
                                0 -> fromIntegral i + 1
                                1 -> fromIntegral i + 5.5
                                2 -> fromIntegral i + 9
                                3 -> fromIntegral i + 13.5
                                _ -> fromIntegral i)

myM' :: Matrix Double
myM' = matrix 4 4 (\(i,j) -> fromIntegral i)

prettyPrint :: (Show a) => Matrix a -> IO ()
prettyPrint m = foldMap print (matrixList m)

matrixList :: (Show a) => Matrix a -> [[a]]
matrixList m = (chunkOf (getNCols m) xs)
 where xs = (horizontalIter (getArray m))

chunkOf :: Int -> [a] -> [[a]]
chunkOf _ [] = []
chunkOf n xs
 | n > 0 = (take n xs) : (chunkOf n (drop n xs))
 | otherwise = error "Only positive numbers allowed"

horizontalIter :: Array (Int, Int) a -> [a]
horizontalIter array = [ array ! (x, y) | y <- [ly.. hy], x <- [lx .. hx]]
 where ((lx, ly), (hx, hy)) = bounds array

listToMatrix :: [a] -> Matrix a
listToMatrix xs = matrix bound bound (\(i, j) -> (((chunkOf bound xs) !! j) !! i)) 
 where bound = round (sqrt (fromIntegral (length xs)))


a :: Matrix Double
a = listToMatrix [1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2]
b :: Matrix Double
b = listToMatrix [-2, 1,2 ,3,3,2,1,-1,4,3,6,5,1,2,7,8]