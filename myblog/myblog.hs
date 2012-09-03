import XMLFile
import MakeHtml
import MyblogParser
import System.Environment

main = do
	[fn] <- getArgs
	txt <- readFile fn
	olds <- xmlfileToData "myblog.xml"
	let	new = parseInputText txt
		dat = new : olds
	makeXmlfile "myblog.xml" dat
	writeFile "myblog.html" $ makeHtml dat
