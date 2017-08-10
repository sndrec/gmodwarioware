DEFINE_BASECLASS( "gamemode_base" )
include( "proptables.lua" )
include( "goalvolumes.lua" )

bossMinigames = {}

function BossMicrogame()
	local tempTable = {}
	table.insert(bossMinigames, tempTable)
	return tempTable
end

mins = Vector(1536, -4096, 0)
maxs = Vector(9728, 4096, 8192)
middle = Vector(5632, 0, 4096)

--curID = curID + 1
--bossMinigames[curID] = {}
--bossMinigames[curID].Title = "Reach the end!"
--bossMinigames[curID].Vars = {}
--bossMinigames[curID].Vars.music = "minigame_6"
--bossMinigames[curID].Vars.length = 53
--bossMinigames[curID].Vars.respawnAtStart = true
--bossMinigames[curID].Vars.curSpawnVolume = {}
--bossMinigames[curID].Vars.curSpawnVolume.mins = Vector(5217,2657,4127)
--bossMinigames[curID].Vars.curSpawnVolume.maxs = Vector(6000,3300,4302)
--bossMinigames[curID].Vars.respawnAtEnd = true
--bossMinigames[curID].Vars.props = {}
--bossMinigames[curID].Vars.ents = {}
--bossMinigames[curID].Vars.gameWinnable = true
--bossMinigames[curID].Start = function()
--end
--bossMinigames[curID].End = function()
--end