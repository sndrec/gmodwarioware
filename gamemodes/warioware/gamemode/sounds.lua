print("peepee")



sound.Add( {
	name = "warioware_waitingforplayers",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/waitingforplayers.mp3"
} )

sound.Add( {
	name = "warioware_boss",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/warioman_boss.mp3"
} )

sound.Add( {
	name = "warioware_fail",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/warioman_fail.mp3"
} )

sound.Add( {
	name = "warioware_gameover",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/warioman_gameover.mp3"
} )

sound.Add( {
	name = "warioware_intro",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/warioman_intro.mp3"
} )

sound.Add( {
	name = "warioware_speedup",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/warioman_speedup.mp3"
} )

sound.Add( {
	name = "warioware_win",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 50,
	pitch = { 100, 100 },
	sound = "gamesound/tf2ware/warioman_win.mp3"
} )

for i = 1, 35, 1 do
	sound.Add( {
		name = "minigame_" .. i,
		channel = CHAN_AUTO,
		volume = 0.5,
		level = 50,
		pitch = { 100, 100 },
		sound = "gamesound/tf2ware/minigame_" .. i .. ".mp3"
	} )
end