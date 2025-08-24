myDebug = {}

function myDebug.out(obj)
    for key, value in pairs(obj) do
        if type(value) == "table" then
            print(key, " : {")
            myDebug.out(value)
            print("}")
        else
            print(key, " : ", value)
        end
    end
end

return myDebug