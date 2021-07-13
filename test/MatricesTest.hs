module MatricesTest where
import Matrices
import qualified Test.QuickCheck as T
import Test.HUnit
m1 :: Matrix Double
m1 = (Matrices.listToMatrix [1,2,3,4,5.5,6.5,7.5,8.5,9,10,11,12,13.5,14.5,15.5,16.5])

testCase36 = assertEqual "given matrix M[0,0] = 1" 1 (get m1 (0,0))
testCase37 = assertEqual "given matrix M[0,3] = 4" 4 (get m1 (0,3))
testCase38 = assertEqual "given matrix M[1,0] = 5.5" 5.5 (get m1 (1,0))
testCase39 = assertEqual "given matrix M[1,2] = 7.5" 7.5 (get m1 (1,2))
testCase40 = assertEqual "given matrix M[2,2] = 11" 11 (get m1 (2,2))
testCase41 = assertEqual "given matrix M[3,0] = 13.5" 13.5 (get m1 (3,0))
testCase42 = assertEqual "given matrix M[3,2] = 15.5" 15.5 (get m1 (3,2))