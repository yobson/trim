import System.Environment
import Data.List.Split

type TextAction = String -> IO String

(>=>) :: (Monad m) => (a -> m b) -> (b -> m c) -> (a -> m c)
(f >=> g) x = f x >>= g
infixl 1 >=>

stripExtM :: TextAction
stripExtM xs = return $ stripExt xs

stripDirM :: TextAction
stripDirM xs = return $ stripPath xs

init' :: [a] -> [a]
init' []  = []
init' [x] = [x]
init' xs  = init xs

concatWith :: a -> [[a]] -> [a]
concatWith a [] = []
concatWith a (x:xs) = concat (x : map (a:) xs)

stripExt' :: String -> String
stripExt' = concatWith '.' . init' . splitOn "."

stripExt :: String -> String
stripExt s | last s == '\n' = stripExt' s ++ "\n"
           | otherwise      = stripExt' s

stripPath :: String -> String
stripPath = last . splitOn "/"

parseCommandLine' :: Int -> String -> TextAction
parseCommandLine' 0 [] = \a -> return a
parseCommandLine' 0 ('{':xs) =               parseCommandLine' 1 xs
parseCommandLine' 1 ('.':xs) = stripExtM >=> parseCommandLine' 1 xs
parseCommandLine' 1 ('/':xs) = stripDirM >=> parseCommandLine' 1 xs
parseCommandLine' 1 ('}':xs) =               parseCommandLine' 0 xs
parseCommandLine' _ _        = error "Invalid pattern"

parseCommandLine :: [String] -> TextAction
parseCommandLine = foldr (\x y -> parseCommandLine' 0 x >=> y) (\a -> return a)

main :: IO ()
main = do
  pipeIn <- getContents
  args   <- getArgs
  let act = parseCommandLine args
  out    <- act pipeIn
  putStr out
