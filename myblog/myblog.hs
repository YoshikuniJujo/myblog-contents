import XMLFile
import MakeHtml
import MyblogParser
import Processing
import System.Environment
import Data.List

main = do
	args <- getArgs
	case args of
		("list" : largs) -> listDiary largs
		("remove" : rargs) -> removeDiary rargs
		("edit" : rargs) -> getDiary rargs
		[fn] -> putDiary fn

putDiary :: FilePath -> IO ()
putDiary fn = do
	txt <- readFile fn
	olds <- xmlfileToData "myblog.xml"
	let	new = parseInputText txt
	(new', uuid) <- addUUID new
	let	dat = maybe (addNew new' olds) (\u -> editDiary u new' olds) uuid
	makeXmlfile "myblog.xml" dat
	writeFile "myblog.html" $ makeHtml dat

addNew :: Diary -> [Diary] -> [Diary]
addNew d@(tags, cnt) ds = let
	len = getLen (lookD "uuid" d) (map (lookD "uuid") ds) + 1
	nd = (("uuidlen", show len) : tags, cnt) in
	nd : ds

editDiary :: String -> Diary -> [Diary] -> [Diary]
editDiary _ _ [] = error "bad UUID"
editDiary u dn@(tags, cnt) (d : ds)
	| checkUUID u d = (("uuidlen", lookD "uuidlen" d) : tags, cnt) : ds
	| otherwise = d : editDiary u dn ds

listDiary :: [String] -> IO ()
listDiary largs = do
	olds <- xmlfileToData "myblog.xml"
	let	u = lookD "uuid"
		t = lookD "title"
		l = read . lookD "uuidlen"
	putStr $ unlines $
		map (\o -> take (l o) (u o) ++ replicate (8 - l o) ' ' ++ t o) olds

removeDiary :: [String] -> IO ()
removeDiary [u] = do
	olds <- xmlfileToData "myblog.xml"
	let	new = deleteDiary u olds
	makeXmlfile "myblog.xml" new
	writeFile "myblog.html" $ makeHtml new

deleteDiary :: String -> [Diary] -> [Diary]
deleteDiary u = reverse . dd . reverse
	where
	dd (d : ds)
		| checkUUID u d = ds
		| otherwise = d : dd ds

getDiary :: [String] -> IO ()
getDiary [u] = do
	olds <- xmlfileToData "myblog.xml"
	let	d = getD u olds
	writeFile "diary.txt" $ makeText d

getD :: String -> [Diary] -> Diary
getD u = gd . reverse
	where
	gd (d@(tags, cnt) : ds)
		| checkUUID u d = (filter ((/= "uuidlen") . fst) tags, cnt)
		| otherwise = gd ds

makeText :: Diary -> String
makeText (tags, cnt) =
	unlines (map (\(t, v) -> t ++ ": " ++ v) tags) ++ "\n" ++ unlines cnt ++
	"."

checkUUID :: String -> Diary -> Bool
checkUUID s d = s `isPrefixOf` lookD "uuid" d

getLen :: String -> [String] -> Int
getLen _ [] = 0
getLen s1 (s2 : ss) = sameLen s1 s2 `max` getLen s1 ss

sameLen :: String -> String -> Int
sameLen [] _ = 0
sameLen _ [] = 0
sameLen (x : xs) (y: ys)
	| x == y = 1 + sameLen xs ys
	| otherwise = 0
