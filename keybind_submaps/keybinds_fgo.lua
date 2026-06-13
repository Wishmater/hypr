-- submap = fgo
hl.define_submap("fgo", function()
    -- use skills
    hl.bind("Q",      hl.dsp.exec_cmd("click 151 775"))
    hl.bind("W",      hl.dsp.exec_cmd("click 257 775"))
    hl.bind("E",      hl.dsp.exec_cmd("click 362 775"))
    hl.bind("A",      hl.dsp.exec_cmd("click 527 775"))
    hl.bind("S",      hl.dsp.exec_cmd("click 637 775"))
    hl.bind("D",      hl.dsp.exec_cmd("click 741 775"))
    hl.bind("Z",      hl.dsp.exec_cmd("click 902 775"))
    hl.bind("X",      hl.dsp.exec_cmd("click 1018 775"))
    hl.bind("C",      hl.dsp.exec_cmd("click 1121 775"))

    -- pick cards / skill target
    hl.bind("code:49", hl.dsp.exec_cmd("click 347 585"))  -- tilde (`)
    hl.bind("1",      hl.dsp.exec_cmd("click 670 585"))
    hl.bind("2",      hl.dsp.exec_cmd("click 958 585"))
    hl.bind("3",      hl.dsp.exec_cmd("click 1288 585"))
    hl.bind("4",      hl.dsp.exec_cmd("click 1605 585"))

    -- pick NP
    hl.bind("SHIFT + 1", hl.dsp.exec_cmd("click 670 335"))
    hl.bind("ALT + 1",   hl.dsp.exec_cmd("click 670 335"))
    hl.bind("SHIFT + 2", hl.dsp.exec_cmd("click 958 335"))
    hl.bind("ALT + 2",   hl.dsp.exec_cmd("click 958 335"))
    hl.bind("SHIFT + 3", hl.dsp.exec_cmd("click 1288 335"))
    hl.bind("ALT + 3",   hl.dsp.exec_cmd("click 1288 335"))

    -- master skills
    hl.bind("Tab",      hl.dsp.exec_cmd("click 1740 485"))
    hl.bind("SHIFT + Q", hl.dsp.exec_cmd("click 1394 485"))
    hl.bind("ALT + Q",  hl.dsp.exec_cmd("click 1394 485"))
    hl.bind("SHIFT + W", hl.dsp.exec_cmd("click 1498 485"))
    hl.bind("ALT + W",  hl.dsp.exec_cmd("click 1498 485"))
    hl.bind("SHIFT + E", hl.dsp.exec_cmd("click 1610 485"))
    hl.bind("ALT + E",  hl.dsp.exec_cmd("click 1610 485"))

    -- select enemies
    hl.bind("F1", hl.dsp.exec_cmd("click 146 145"))
    hl.bind("F2", hl.dsp.exec_cmd("click 448 145"))
    hl.bind("F3", hl.dsp.exec_cmd("click 746 145"))

    -- enter/exit card picking
    hl.bind("space", hl.dsp.exec_cmd("click 1724 891"))

    hl.bind("escape", hl.dsp.submap("reset"))
end)
