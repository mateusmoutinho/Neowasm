function main()

    darwin.silverchain.generate({
        src = "src",
        project_short_cut = "NeoWasm",
        tags = {  "consts", "macros", "types", "globals", "fdeclare", "fdefine" }
    })

    local MAX_CONNTENT = darwin.camalgamator.ONE_MB * 20
    local MAX_RECURSION = 100

    local lincense = "/* " .. darwin.dtw.load_file("LICENSE") .. " */ \n"

    local onefile = darwin.camalgamator.generate_amalgamation("src/one.c", MAX_CONNTENT, MAX_RECURSION)
    onefile = lincense .. onefile

    darwin.dtw.write_file("release/NeoWasmOne.c", onefile)

    local only_declare = darwin.camalgamator.generate_amalgamation("src/imports/imports.fdeclare.h", MAX_CONNTENT,
    MAX_RECURSION)
    only_declare = lincense .. only_declare
    darwin.dtw.write_file("release/NeoWasm.h", only_declare)



    local only_definition = darwin.camalgamator.generate_amalgamation_with_callback("src/imports/imports.fdefine.h",
        function(import, path)
            if darwin.dtw.ends_with(import, ".c") then
                return "include-once"
            end
            return "dont-include"
        end,
        MAX_CONNTENT,
        MAX_RECURSION
    )
    only_definition = '#include "NeoWasm.h"\n' .. only_definition

    only_definition = lincense .. only_definition

    darwin.dtw.write_file("release/NeoWasm.c", only_definition)

end
