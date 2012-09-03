module Processing (
	addUUID
) where

import Data.UUID.V4

addUUID :: ([(String, String)], [String]) -> IO ([(String, String)], [String])
addUUID (tags, cnt) = do
	u <- nextRandom
	return (("uuid", show u) : tags, cnt)
