local function randomDelay(min, max)
    local delay = math.random() * (max - min) + min
    task.wait(delay)
end
local function sendWithAntiSpam(sendFunc, text, minDelay, maxDelay)
    randomDelay(minDelay or 0.5, maxDelay or 1.5)
    return sendFunc(text)
end
return { sendWithAntiSpam = sendWithAntiSpam }