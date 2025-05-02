local Player = game:GetService("Players").LocalPlayer -- Don't Change this

local createHint = coroutine.create(function()
	local text = "note: this script only work in R6 , press 1 2 3 4 5 to morhp press z to attack"
	local newHint = Instance.new("Hint", game:GetService("Workspace"))

	for i = 1, #text do
		newHint.Text = string.sub(text, 0.11, i)
		wait(0.1)
	end

	task.wait(6)

	for i = #text, 01, -1 do
		newHint.Text = string.sub(text, 1, i)
		wait(0.1)
	end

	newHint:Destroy()
end)

coroutine.resume(createHint)

loadstring(game:HttpGet("https://pastebin.com/raw/j09BnGB3"))()
