module Scene where
{- 
This module is part of chapter 1 of The Ray Tracer Challenge

It's goal is too show how tuples can be used in order to calculate projectiles in an environment
-}    
import Tuples

data Projectile a = Projectile { position :: Tuple a, velocity :: Tuple a} 
 deriving Show

data Environment a = Environment { gravity :: Tuple a, wind :: Tuple a }
--- s = Projectile
--- a = Enviroment
tick2 :: (Fractional a) =>  Environment a -> Projectile a -> Projectile a
tick2 env proj = let pos = position proj + velocity proj 
                     vel =  velocity proj + gravity env + wind env
                   in Projectile pos vel 

p = Projectile (point 0.0 1.0 0.0) (normalize (vector 1.0 1.0 0.0))
e = Environment (vector 0.0 (-0.1) 0.0) (vector (-0.001) 0 0)

runScenario :: (Environment Double) -> Scenario (Projectile Double) (Projectile Double)
runScenario env = (Scenario $ \s0 -> let s1 = tick2 env s0
                                     in (s0, s1)) 

scene :: (Environment Double) -> Int -> Scenario (Projectile Double) [Projectile Double]
scene env n = sequence (replicate n (runScenario env))

main :: IO ()
main = do
  putStrLn "Enter the number of iterations: "
  n <- getLine
  putStrLn "Enter the number of scalar multiplier for velocity of projectile: "
  v <- getLine
  let result = map position (fst $ tick (scene e (read n)) (Projectile (position p) ((velocity p)* (pure (read v)))))
  let hit = filter (\x -> getY x > 0) result
  print hit
  if getY (last hit) > 0 && length hit == (read n)
      then putStrLn "Try more iterations or higher velocity"
      else do
          putStrLn "Took # iterations:"
          print (length hit)

newtype Scenario s a = Scenario { tick :: s -> (a, s) } 

instance Functor (Scenario s) where
 fmap f x = Scenario $ \s0 ->  let (a, s1) = (tick x s0)
                               in (f a, s1)

instance Applicative (Scenario s) where
 pure a = Scenario $ \s -> (a, s)
 sf <*> sa = Scenario $ \s0 -> let (fs, s1) = (tick sf s0)
                                   (a, s2) = (tick sa s1)
                               in (fs a, s2) 

instance Monad (Scenario s) where
 return a = pure a
 sa >>= asb = Scenario $ \s0 -> let (a, s1) = tick sa s0
                                in (tick (asb a) s1)
