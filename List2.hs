module List2 where
	import Data.List.Split

	data Element a = Single a | Multiple Int a deriving (Show, Eq)
	--instance Show Element where
	--	show Single = "Single"
	--	show Multiple = "Multiple"

	encodeModified :: (Eq a) => [a] -> [Element a]
	encodeModified = foldr func [] where
		func newEl [] = [Single newEl]
		func newEl ((Single el):els)
			| newEl == el = ((Multiple 2 el):els)
			| otherwise   = ((Single newEl):(Single el):els)
		func newEl ((Multiple num el):els)
			| newEl == el = ((Multiple (num + 1) el):els) 
			| otherwise   = ((Single newEl):(Multiple num el):els)


	decodeModified :: (Eq a) => [Element a] -> [a]
	decodeModified = foldl func [] where
		func list (Single el) = list ++ [el]
		func list (Multiple num el) = list ++ replicate num el

	dupli :: [a] -> [a]
	dupli = foldl (\list el -> list ++ [el, el]) []

	dupli' :: [a] -> [a]
	dupli' list = concat [[x,x] | x <- list]

	repli :: [a] -> Int -> [a]
	repli list num = concat [replicate num x | x <- list]

	dropEvery :: [a] -> Int -> [a]
	dropEvery [] _ = []
	dropEvery list num = concat $ map (take (num - 1)) (chunksOf num list)

	split :: [a] -> Int -> ([a],[a])
	split = flip splitAt

	slice :: [a] -> Int -> Int -> [a]
	slice list start end = drop (start - 1) . take end $ list

	rotate :: [a] -> Int -> [a]
	rotate [] _ = []
	rotate l  0 = l
	rotate list num
		| num > 0   = joiner $ splitAt num list
		| num < 0   = joiner $ splitAt ((length list) + num) list
			where joiner = \(x,y) -> y ++ x

	removeAt :: Int -> [a] -> (a,[a])
	removeAt num list = (list !! (num - 1), remains)
		where remains = take (num - 1) list ++ drop num list